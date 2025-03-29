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
import 'package:logger/logger.dart';

final alistProvider =
    NotifierProvider<AlistNotifier, AlistState>(AlistNotifier.new);

class AlistNotifier extends Notifier<AlistState> {
  List<String> stdOut = [];
  Logger logger = Logger();

  @override
  AlistState build() {
    return AlistState(
      workDir: ref.read(settingsProvider.select((s) => s.workingDirectory)),
      alistArgs: ref.read(settingsProvider.select((s) => s.alistArgs)),
      proxy: ref.read(settingsProvider.select((s) => s.proxy ?? '')),
    );
  }

  Future<void> setWorkDir(String workDir) async {
    endAlist();
    ref.read(settingsProvider.notifier).setWorkingDirectory(workDir);
    state = state.copyWith(workDir: workDir);
  }

  Future<void> setAlistArgs(List<String> args) async {
    endAlist();
    ref.read(settingsProvider.notifier).setAlistArgs(args);
    state = state.copyWith(alistArgs: args);
  }

  Future<void> setProxy(String proxy) async {
    ref.read(settingsProvider.notifier).setProxy(proxy);
    state = state.copyWith(proxy: proxy);
  }

  void addOutput(String text) {
    if (text.contains('\n') && text.contains('[')) {
      List<String> lines = text.split('\n');
      for (String line in lines) {
        if (line.isNotEmpty) {
          stdOut.add(line);
        }
        if (line.contains('start HTTP server @')) {
          checkState(line);
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
    state = state.copyWith(isRunning: true, url: url);
  }

  Future<void> startAlist() async {
    //state = state.copyWith(isRunning: true);
    final Map<String, String> envVars = Map.from(Platform.environment);
    if (state.proxy != '') {
      envVars['http_proxy'] = state.proxy;
      envVars['https_proxy'] = state.proxy;
      addOutput('Proxy: ${state.proxy}');
    }
    await changeTray(true);
    Process process;

    if (Platform.isWindows) {
      process = await Process.start(
        '${state.workDir}\\alist.exe',
        state.alistArgs,
        workingDirectory: state.workDir,
        environment: envVars,
      );
    } else {
      process = await Process.start(
        '${state.workDir}/alist',
        state.alistArgs,
        workingDirectory: state.workDir,
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
          '${state.workDir}\\alist.exe', ['admin', 'random'],
          workingDirectory: state.workDir);
    } else {
      alistAdmin = await Process.start(
          '${state.workDir}/alist', ['admin', 'random'],
          workingDirectory: state.workDir);
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
    try {
      if (Platform.isWindows) {
        alistVersion = await Process.start(
            '${state.workDir}\\alist.exe', ['version'],
            workingDirectory: state.workDir);
      } else {
        alistVersion = await Process.start(
            '${state.workDir}/alist', ['version'],
            workingDirectory: state.workDir);
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
    } on ProcessException catch (e) {
      logger.e('Error: ${e.message}');
    }
  }

  Future<void> fetchLatestVersion() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/AlistGo/alist/releases/latest'));
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
    String targetArchiveFile = '${state.workDir}/alistnew.zip';
    await Dio().download(downloadLink, targetArchiveFile);
    FileHelper.unzipFile(targetArchiveFile, state.workDir);
    await File(targetArchiveFile).delete();
    getAlistCurrentVersion(addToOutput: false);
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
    //startAlist();
  }

  Future<void> upgradeAlist(String downloadLink) async {
    state = state.copyWith(upgradeStatus: UpgradeStatus.installing);
    String targetArchiveFile = '${state.workDir}/alistnew.zip';
    String backupFolder = '${state.workDir}/.old';
    String currentAlist = Platform.isWindows
        ? '${state.workDir}/alist.exe'
        : '${state.workDir}/alist';
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
    FileHelper.unzipFile('${state.workDir}/alistnew.zip', state.workDir);
    await File(targetArchiveFile).delete();
    getAlistCurrentVersion(addToOutput: false);
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
    startAlist();
  }
}
