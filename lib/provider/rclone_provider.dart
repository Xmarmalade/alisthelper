import 'dart:io';

import 'package:alisthelper/model/rclone_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rcloneProvider =
    StateNotifierProvider<RcloneNotifier, RcloneState>((ref) {
  String rcloneDirectory = ref
      .watch(settingsProvider.select((settings) => settings.rcloneDirectory));
  List<String> rcloneArgs =
      ref.watch(settingsProvider.select((settings) => settings.rcloneArgs));
  String proxy =
      ref.watch(settingsProvider.select((settings) => settings.proxy ?? ''));

  return RcloneNotifier(rcloneDirectory, rcloneArgs, proxy);
});

class RcloneNotifier extends StateNotifier<RcloneState> {
  List<String> stdout = [];
  String rcloneDirectory;
  List<String> rcloneArgs;
  String proxy;

  RcloneNotifier(this.rcloneDirectory, this.rcloneArgs, this.proxy)
      : super(const RcloneState());

  void addOutput(String text) {
    stdout.add(text);
    state = state.copyWith(output: stdout);
  }

  Future<void> startRclone() async {
    Process process;

    try {
  if (Platform.isWindows) {
    process = await Process.start('$rcloneDirectory\\rclone.exe', rcloneArgs,
        workingDirectory: rcloneDirectory);
  } else {
    process = await Process.start('$rcloneDirectory/rclone', rcloneArgs,
        workingDirectory: rcloneDirectory);
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
} on Exception catch (e) {
  addOutput(e.toString());
}
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
      process = await Process.start('$rcloneDirectory\\rclone.exe', ['version'],
          workingDirectory: rcloneDirectory);
    } else {
      process = await Process.start('$rcloneDirectory/rclone', ['version'],
          workingDirectory: rcloneDirectory);
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
