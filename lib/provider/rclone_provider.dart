import 'dart:convert';
import 'dart:io';
import 'package:alisthelper/model/virtual_disk_state.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:alisthelper/model/rclone_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

/// **IMPORTANT NOTE**:
///
/// The http package will add `charset=utf-8` in content-type header by default.
/// This will cause the rclone server to return a 400 error.
/// Use [Dio] instead of http package.
/// https://github.com/dart-lang/http/issues/184

final rcloneProvider =
    NotifierProvider<RcloneNotifier, RcloneState>(RcloneNotifier.new);

class RcloneNotifier extends Notifier<RcloneState> {
  late String rcloneDirectory;
  late List<String> rcloneArgs;
  late Options option;
  String webDavAccount = '';
  List<VirtualDiskState> vdisks = [];
  List<String> stdout = [];
  List<String> alistRoot = [];
  Dio dio = Dio();
  String rcloneAuth = '';

  @override
  RcloneState build() {
    webDavAccount = ref.watch(settingsProvider.select((s) => s.webdavAccount));
    rcloneDirectory =
        ref.watch(settingsProvider.select((s) => s.rcloneDirectory));
    rcloneArgs = ref.watch(settingsProvider.select((s) => s.rcloneArgs));
    vdisks = ref
        .watch(persistenceProvider.select((p) => p.getVdisks()))
        .map((e) => VirtualDiskState.fromJson(jsonDecode(e)))
        .toList();
    rcloneAuth = TextUtils.encodeCredentials(rcloneArgs);
    option = Options(
      headers: {
        'Authorization': 'Basic $rcloneAuth',
        'Content-Type': 'application/json',
      },
    );
    return RcloneState(vdList: vdisks, webdavAccount: webDavAccount);
  }

  Future<void> fetchAlistToken() async {
    final String alistUrl = ref.watch(alistProvider).url;
    final List<String> credentials =
        TextUtils.accountParser(state.webdavAccount);
    final response = await dio.post('$alistUrl/api/auth/login',
        data: ({
          'username': credentials[0],
          'password': credentials[1],
          'otp_code': ''
        }));
    if (response.statusCode == 200) {
      final token = response.data['data']['token'];
      state = state.copyWith(alistToken: token);
    }
  }

  Future<void> fetchAlistRootPath() async {
    final String alistUrl = ref.watch(alistProvider).url;

    if (state.alistToken.isEmpty) {
      await fetchAlistToken();
    }

    final response = await dio.post('$alistUrl/api/fs/list',
        data: ({
          "path": "/",
          "password": "",
          "page": 1,
          "per_page": 0,
          "refresh": false
        }),
        options: Options(headers: {
          'Authorization': state.alistToken,
        }));

    if (response.statusCode == 200) {
      List contents = response.data['data']['content'];
      alistRoot = contents.map((e) => e['name'] as String).toList();
      state = state.copyWith(alistRoot: alistRoot);
    }
  }

  void toggleMount(VirtualDiskState vd) {
    if (vd.isMounted) {
      unmountRemote(vd);
      vd = vd.copyWith(isMounted: false);
    } else {
      mountRemote(vd);
      vd = vd.copyWith(isMounted: true);
    }
    final index = vdisks.indexWhere((element) => element.name == vd.name);
    vdisks[index] = vd;
    state = state.copyWith(vdList: vdisks);
  }

  void add(VirtualDiskState vd) {
    vdisks.add(vd);
    addRemote(vd);
    saveVdisks();
    syncMount();
    state = state.copyWith(vdList: vdisks);
  }

  void modify(VirtualDiskState vd) {
    final index = vdisks.indexWhere((element) => element.name == vd.name);
    toggleMount(vdisks[index]);
    vdisks[index] = vd;
    saveVdisks();
    syncMount();
    state = state.copyWith(vdList: vdisks);
  }

  Future<void> saveVdisks() async {
    vdisks = vdisks.map((e) => e.copyWith(isMounted: false)).toList();
    ref
        .read(persistenceProvider)
        .setVdisks(vdisks.map((e) => jsonEncode(e.toJson())).toList());
  }

  void deleteSpecific(VirtualDiskState vd) {
    vdisks.remove(vd);
    deleteRemote(vd);
    saveVdisks();
    state = state.copyWith(vdList: vdisks);
  }

  Future<void> syncRemote() async {
    final response = await dio.post(
      '${state.url}/config/listremotes',
      data: jsonEncode({}),
      options: option,
    );

    if (response.statusCode == 200 && response.data['remotes'] != null) {
      final remotes =
          (response.data)['remotes'].map<String>((e) => e.toString()).toList();
      state = state.copyWith(remoteList: remotes);

      for (String remote in remotes) {
        if (!vdisks.any((element) => element.name == remote)) {
          debugPrint('Extra remote: $remote');
          deleteRemote(VirtualDiskState(name: remote));
        }
      }
    } else {
      // Handle error
    }
  }

  Future<void> addRemote(VirtualDiskState vd) async {
    final List<String> credentials =
        TextUtils.accountParser(state.webdavAccount);
    final String alistUrl = ref.watch(alistProvider).url;

    final response = await dio.post(
      '${state.url}/config/create',
      data: jsonEncode({
        'parameters': {
          'url': '$alistUrl/dav/${vd.path}',
          'vendor': vd.name,
          'user': credentials[0],
          'pass': credentials[1],
        },
        'name': vd.name,
        'type': 'webdav',
      }),
      options: option,
    );

    if (response.statusCode == 200) {
      syncRemote();
    } else {
      // Handle error
    }
  }

  Future<void> deleteRemote(VirtualDiskState vd) async {
    final response = await dio.post(
      '${state.url}/config/delete',
      data: jsonEncode({'name': vd.name}),
      options: option,
    );

    if (response.statusCode == 200) {
      // Handle success
      syncRemote();
    } else {
      // Handle error
    }
  }

  Future<void> mountRemote(VirtualDiskState vd) async {
    if (!vd.isMounted) {
      final response = await dio.post(
        '${state.url}/mount/mount',
        data: jsonEncode({
          'fs': '${vd.name}:',
          'mountPoint': '${vd.mountPoint}:',
          'mountType': '',
          'vfsOpt': {},
          'mountOpt': {
            'ExtraFlags': vd.extraFlags,
            'ExtraOptions': [],
            'VolumeName': vd.name.toUpperCase(),
          }
        }),
        options: option,
      );

      if (response.statusCode == 200) {
        // Handle success
      } else {
        // Handle error
      }
    }
  }

  Future<void> unmountRemote(vd) async {
    if (vd.isMounted) {
      final response = await dio.post(
        '${state.url}/mount/unmount',
        data: jsonEncode({'mountPoint': '${vd.mountPoint}:'}),
        options: option,
      );

      if (response.statusCode == 200) {
        // Handle success
      } else {
        // Handle error
      }
    }
  }

  Future<void> syncMount() async {
    final response = await dio.post(
      '${state.url}/mount/listmounts',
      options: option,
      data: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      // Handle success
      List ls = response.data['mountPoints'];
      for (int i = 0; i < vdisks.length; i++) {
        VirtualDiskState vd = vdisks[i];
        if (ls.any((element) => element['Fs'] == '${vd.name}:')) {
          vdisks[i] = vd.copyWith(isMounted: true);
        } else {
          vdisks[i] = vd.copyWith(isMounted: false);
        }
      }
      state = state.copyWith(vdList: vdisks);
    } else {
      // Handle error
    }
  }

  /// mount all vdisks if their isMounted is true
  Future<void> mount() async {
    for (VirtualDiskState vd in vdisks) {
      if (vd.autoMount) {
        toggleMount(vd);
      }
    }
  }

  // **************************************************************************
  // Rclone
  // **************************************************************************

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
      state = state.copyWith(url: url, isRunning: true);
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

    syncRemote();
    fetchAlistRootPath();
    mount();
  }

  Future<void> endRclone() async {
    vdisks = vdisks.map((e) => e.copyWith(isMounted: false)).toList();
    state = state.copyWith(vdList: vdisks);
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

  Future<void> getRcloneInfo() async {
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
      _parseVersion(text);
      addOutput(text);
    });
    process.stderr.listen((data) {
      String text = TextUtils.stdDecode(data, false);
      addOutput(text);
    });
  }

  void _parseVersion(String output) {
    final versionRegExp = RegExp(r'rclone v([\d.]+)');
    final match = versionRegExp.firstMatch(output);
    if (match != null) {
      final version = 'v${match.group(1)}';
      print('Current version: $version');
      state = state.copyWith(currentVersion: version);
    }
  }

  static Future<void> endRcloneProcess() async {
    if (Platform.isWindows) {
      await Process.start('taskkill', ['/f', '/im', 'rclone.exe']);
    } else {
      await Process.start('pkill', ['rclone']);
    }
  }
}
