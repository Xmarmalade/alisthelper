import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alisthelper/utils/native/tray_helper.dart';
import 'package:http/http.dart' as http;

import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alistProvider = StateNotifierProvider<AlistNotifier, AlistState>((ref) {
  String workingDirectory = ref
      .watch(settingsProvider.select((settings) => settings.workingDirectory));
  List<String> alistArgs =
      ref.watch(settingsProvider.select((settings) => settings.alistArgs));
  String proxy =
      ref.watch(settingsProvider.select((settings) => settings.proxy ?? ''));

  return AlistNotifier(workingDirectory, alistArgs, proxy);
});

class AlistNotifier extends StateNotifier<AlistState> {
  List<String> stdOut = [];
  String workingDirectory;
  List<String> alistArgs;
  String proxy;

  AlistNotifier(this.workingDirectory, this.alistArgs, this.proxy)
      : super(AlistState());

  void addOutput(String text) {
    checkState(text);
    stdOut.add(text);
    state = state.copyWith(output: stdOut);
  }

  void checkState(String text) {
    if (text.contains('start ') && text.contains('server')) {
      if (text.contains('FATA')) {
        text = text.split('FATA')[0].trim();
      }
      String port = text.split('@')[1].trim().split(':')[1].trim();
      String url = 'http://localhost:$port';
      state = state.copyWith(url: url);
    }
  }

  Future<void> startAlist() async {
    state = state.copyWith(isRunning: true);
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
  Future<void> getAlistAdmin() async {
    Process alistAdmin;
    if (Platform.isWindows) {
      alistAdmin = await Process.start(
          '$workingDirectory\\alist.exe', ['admin'],
          workingDirectory: workingDirectory);
    } else {
      alistAdmin = await Process.start('$workingDirectory/alist', ['admin'],
          workingDirectory: workingDirectory);
    }
    alistAdmin.stderr.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      String password = text.split('password:')[1].trim();
      addOutput(text);
      addOutput(password);
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
    final latest = json['tag_name'] as String;
    state = state.copyWith(latestVersion: latest);
    //print('Latest release: $latest');
  }

/*   Future<void> isAlistRunning() async {
    if (Platform.isWindows) {
      var tasklist =
          await Process.run('tasklist', ['/fi', 'imagename eq alist.exe']);
      if (tasklist.stdout.toString().contains('alist')) {
        state = state.copyWith(isRunning: true);
      }
    }
    state = state.copyWith(isRunning: false);
  } */
}

class AlistState {
  final bool isRunning;
  final List<String> output;
  final String url;
  final String currentVersion;
  final String latestVersion;

  AlistState({
    this.isRunning = false,
    this.output = const [],
    this.url = 'http://localhost:5244',
    this.currentVersion = 'v1.0.0',
    this.latestVersion = 'v1.0.0',
  });

  AlistState copyWith({
    bool? isRunning,
    List<String>? output,
    String? url,
    String? currentVersion,
    String? latestVersion,
  }) {
    return AlistState(
      isRunning: isRunning ?? this.isRunning,
      output: output ?? this.output,
      url: url ?? this.url,
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion ?? this.latestVersion,
    );
  }
}
