import 'dart:io';

import 'package:alisthelper/model/rclone_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rcloneProvider =
    StateNotifierProvider<RcloneNotifier, RcloneState>((ref) {
  String workingDirectory = ref
      .watch(settingsProvider.select((settings) => settings.workingDirectory));
  List<String> rcloneArgs =
      ref.watch(settingsProvider.select((settings) => settings.rcloneArgs));
  String proxy =
      ref.watch(settingsProvider.select((settings) => settings.proxy ?? ''));

  return RcloneNotifier(workingDirectory, rcloneArgs, proxy);
});

class RcloneNotifier extends StateNotifier<RcloneState> {
  List<String> stdout = [];
  String workingDirectory;
  List<String> rcloneArgs;
  String proxy;

  RcloneNotifier(this.workingDirectory, this.rcloneArgs, this.proxy)
      : super(const RcloneState());

  void addOutput(String text) {
    stdout.add(text);
    state = state.copyWith(output: stdout);
  }

  Future<void> startRclone() async {
    Process process;

    if (Platform.isWindows) {
      process = await Process.start('$workingDirectory\\rclone.exe', rcloneArgs,
          workingDirectory: workingDirectory);
    } else {
      process = await Process.start('$workingDirectory/rclone', rcloneArgs,
          workingDirectory: workingDirectory);
    }
    state = state.copyWith(isRunning: true);
    process.stdout.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      addOutput(text);
    });
    process.stderr.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      addOutput(text);
    });
  }

  Future<void> endRclone() async {
    state = state.copyWith(isRunning: false);
    Process process;
    if (Platform.isWindows) {
      process = await Process.start('taskkill', ['/f', '/im', 'rclone.exe']);
    } else {
      process = await Process.start('pkill', ['rclone']);
    }
    //await changeTray(false);
    process.stdout.listen((data) {
      String text = TextUtils.stdDecode(data, true);
      addOutput(text);
    });
  }


  void getRcloneInfo() async {
    Process process;
    if (Platform.isWindows) {
      process = await Process.start('$workingDirectory\\rclone.exe', ['version'],
          workingDirectory: workingDirectory);
    } else {
      process = await Process.start('$workingDirectory/rclone', ['version'],
          workingDirectory: workingDirectory);
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

  static Future<void> endRcloneProcess() async {
    if (Platform.isWindows) {
      await Process.start('taskkill', ['/f', '/im', 'rclone.exe']);
    } else {
      await Process.start('pkill', ['rclone']);
    }
  }

}
