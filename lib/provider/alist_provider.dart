import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alisthelper/model/alist_state.dart';
import 'package:alisthelper/utils/native/tray_helper.dart';
import 'package:alisthelper/utils/native/file_helper.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alistProvider =
    NotifierProvider<AlistNotifier, AlistState>(AlistNotifier.new);

class AlistNotifier extends Notifier<AlistState> {
  late String workingDirectory;
  late List<String> alistArgs;
  late String proxy;
  List<String> stdOut = [];

  @override
  AlistState build() {
    final settings = ref.watch(settingsProvider);
    workingDirectory = settings.workingDirectory;
    alistArgs = settings.alistArgs;
    proxy = settings.proxy ?? '';
    return const AlistState();
  }

  void addOutput(String text) {
    if (text.contains('start HTTP server')) {
      checkState(text);
    }
    if (text.contains('\n')) {
      List<String> lines = text.split('\n');
      for (String line in lines) {
        if (line.isNotEmpty) {
          stdOut.add(line);
        }
      }
    } else {
      stdOut.add(text);
    }
    state = state.copyWith(output: stdOut);
  }

  void checkState(String text) {
    if (text.contains('FATA')) {
      text = text.split('FATA')[0].trim();
    }
    String port = text.split('@')[1].trim().split(':')[1].trim();
    String url = 'http://localhost:$port';
    state = state.copyWith(url: url);
    state = state.copyWith(isRunning: true);
  }

  Future<void> startAlist() async {
    //state = state.copyWith(isRunning: true);
    final Map<String, String> envVars = Map.from(Platform.environment);
    if (proxy != '') {
      envVars['http_proxy'] = proxy;
      envVars['https_proxy'] = proxy;
      addOutput('Proxy: $proxy');
    }
    await changeTray(true);
    Process process;

    if (Platform.isWindows) {
      process = await Process.start(
        '$workingDirectory\\alist.exe',
        alistArgs,
        workingDirectory: workingDirectory,
        environment: envVars,
      );
    } else {
      process = await Process.start(
        '$workingDirectory/alist',
        alistArgs,
        workingDirectory: workingDirectory,
        environment: envVars,
      );
    }

    process.stdout.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      addOutput(text);
    });
    process.stderr.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      addOutput(text);
    });
  }

  Future<void> endAlist() async {
    state = state.copyWith(isRunning: false);
    Process process;
    if (Platform.isWindows) {
      process = await Process.start('taskkill', ['/f', '/im', 'alist.exe']);
    } else {
      process = await Process.start('pkill', ['alist']);
    }
    await changeTray(false);
    process.stdout.listen((data) {
      String text = TextUtils.stdDecode(data, true);
      addOutput(text);
    });
  }

  static Future<void> endAlistProcess() async {
    if (Platform.isWindows) {
      await Process.start('taskkill', ['/f', '/im', 'alist.exe']);
    } else {
      await Process.start('pkill', ['alist']);
    }
  }

  //get alist admin
  Future<void> genRandomPwd() async {
    Process alistAdmin;
    if (Platform.isWindows) {
      alistAdmin = await Process.start(
          '$workingDirectory\\alist.exe', ['admin', 'random'],
          workingDirectory: workingDirectory);
    } else {
      alistAdmin = await Process.start(
          '$workingDirectory/alist', ['admin', 'random'],
          workingDirectory: workingDirectory);
    }
    alistAdmin.stderr.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      if (text.contains('password:')) {
        String password = text.split('password:')[1].trim();
        addOutput(password);
      }
      addOutput(text);
    });
  }

  //get alist version
  Future<void> getAlistCurrentVersion({required bool addToOutput}) async {
    Process alistVersion;
    if (Platform.isWindows) {
      alistVersion = await Process.start(
          '$workingDirectory\\alist.exe', ['version'],
          workingDirectory: workingDirectory);
    } else {
      alistVersion = await Process.start('$workingDirectory/alist', ['version'],
          workingDirectory: workingDirectory);
    }
    alistVersion.stdout.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      if (text.contains('Version')) {
        String versionInfo = text
            .split('Go Version:')[1]
            .split('Version:')[1]
            .trim()
            .split('\n')[0]
            .trim();
        state = state.copyWith(currentVersion: versionInfo);
      }
      if (addToOutput) {
        addOutput(text);
      }
    });
  }

  Future<void> fetchLatestVersion() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/alist-org/alist/releases/latest'));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    try {
      String latest = json['tag_name'];
      List assets = json['assets'];
      String platformKey = Platform.isWindows
          ? 'windows'
          : (Platform.isMacOS ? 'darwin' : 'linux');
      List<Map> assetsForSpecificPlatform = [];
      for (Map asset in assets) {
        if (asset['name'].contains(platformKey)) {
          //remove the asset if it's not for the current platform
          assetsForSpecificPlatform.add(asset);
        }
      }
      // Preventing uninitialized version string
      if (state.currentVersion == "v1.0.0") {
        getAlistCurrentVersion(addToOutput: false);
      }
      state = state.copyWith(
          latestVersion: latest,
          newReleaseAssets: assetsForSpecificPlatform,
          upgradeStatus: UpgradeStatus.idle);
    } catch (e) {
      throw Exception(
          '$e\nFailed to get latest version when fetching: ${json.toString()}');
    }
  }

  Future<void> installAlist(String downloadLink) async {
    state = state.copyWith(upgradeStatus: UpgradeStatus.installing);
    String targetArchiveFile = '$workingDirectory/alistnew.zip';
    await Dio().download(downloadLink, targetArchiveFile);
    FileHelper.unzipFile(targetArchiveFile, workingDirectory);
    await File(targetArchiveFile).delete();
    getAlistCurrentVersion(addToOutput: false);
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
    //startAlist();
  }

  Future<void> upgradeAlist(String downloadLink) async {
    state = state.copyWith(upgradeStatus: UpgradeStatus.installing);
    String targetArchiveFile = '$workingDirectory/alistnew.zip';
    String backupFolder = '$workingDirectory/.old';
    String currentAlist = Platform.isWindows
        ? '$workingDirectory/alist.exe'
        : '$workingDirectory/alist';
    await Dio().download(downloadLink, targetArchiveFile);
    endAlist();
    if (!await Directory(backupFolder).exists()) {
      await Directory(backupFolder).create();
    }
    if (await File('$backupFolder/alist-${state.currentVersion}.exe')
        .exists()) {
      await File('$backupFolder/alist-${state.currentVersion}.exe').delete();
    }
    await File(currentAlist)
        .rename('$backupFolder/alist-${state.currentVersion}.exe');
    FileHelper.unzipFile('$workingDirectory/alistnew.zip', workingDirectory);
    await File(targetArchiveFile).delete();
    getAlistCurrentVersion(addToOutput: false);
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
    startAlist();
  }
}
