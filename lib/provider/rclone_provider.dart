import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:alisthelper/model/rclone_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rcloneProvider =
    NotifierProvider<RcloneNotifier, RcloneState>(RcloneNotifier.new);

class RcloneNotifier extends Notifier<RcloneState> {
  late String rcloneDirectory;
  late List<String> rcloneArgs;
  late String proxy;
  List<String> stdout = [];

  @override
  RcloneState build() {
    rcloneDirectory = ref
        .watch(settingsProvider.select((settings) => settings.rcloneDirectory));
    rcloneArgs =
        ref.watch(settingsProvider.select((settings) => settings.rcloneArgs));
    proxy =
        ref.watch(settingsProvider.select((settings) => settings.proxy ?? ''));
    return const RcloneState();
  }

  void addOutput(String text) {
    checkState(text);
    stdout.add(text);
    state = state.copyWith(output: stdout);
  }

  void checkState(String text) {
    if (text.contains('Serving remote control on')) {
      if (text.contains('FATA')) {
        text = text.split('FATA')[0].trim();
      }
      String port =
          text.split('http://127.0.0.1:')[1].trim().split('/')[0].trim();
      String url = 'http://localhost:$port';
      state = state.copyWith(url: url);
      state = state.copyWith(isRunning: true);
    }
  }

  Future<void> startRclone() async {
    Process process;

    try {
      if (Platform.isWindows) {
        process = await Process.start(
            '$rcloneDirectory\\rclone.exe', rcloneArgs,
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

  Future<void> updateRemote(String url) async {
    final response = await http.post(
      Uri.parse('$url/config/listremotes'),
      headers: {
        'authorization': 'Basic YWRtaW46YWRtaW4=',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Remotes: ${data['remotes']}');
    } else {
      print('Failed to fetch remotes');
    }
  }
}
