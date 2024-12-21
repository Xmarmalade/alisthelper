import 'dart:convert';
import 'dart:io';
import 'package:alisthelper/model/updater_state.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/utils/native/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

final updaterProvider =
    NotifierProvider<UpdaterNotifier, UpdaterState>(UpdaterNotifier.new);

class UpdaterNotifier extends Notifier<UpdaterState> {
  Dio dio = Dio();

  @override
  UpdaterState build() {
    return UpdaterState(
      rcloneCurrentVersion: ref.watch(rcloneProvider).currentVersion,
      workDir: ref.watch(settingsProvider).rcloneDirectory,
    );
  }

  Future<void> getRcloneCurrentVersion() async {
    await ref.read(rcloneProvider.notifier).getRcloneInfo();
  }

  Future<void> fetchLatestVersion() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/rclone/rclone/releases/latest'));
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
      if (state.rcloneCurrentVersion == "v1.0.0") {
        getRcloneCurrentVersion();
      }
      state = state.copyWith(
          rcloneLatestVersion: latest,
          rcloneAssets: assetsForSpecificPlatform,
          upgradeStatus: UpgradeStatus.idle);
    } catch (e) {
      throw Exception(
          '$e\nFailed to get latest version when fetching: ${json.toString()}');
    }
  }

  Future<void> installRclone(String downloadLink) async {
    state = state.copyWith(upgradeStatus: UpgradeStatus.installing);
    String targetArchiveFile = '${state.workDir}/rclonenew.zip';
    await Dio().download(downloadLink, targetArchiveFile);
    FileHelper.extractRclone(targetArchiveFile, state.workDir);
    await File(targetArchiveFile).delete();
    getRcloneCurrentVersion();
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
    //startAlist();
  }

  Future<void> upgradeRclone(String downloadLink) async {
    state = state.copyWith(upgradeStatus: UpgradeStatus.installing);
    String targetArchiveFile = '${state.workDir}/rclonenew.zip';
    String backupFolder = '${state.workDir}/.old';
    String currentAlist = Platform.isWindows
        ? '${state.workDir}/rclone.exe'
        : '${state.workDir}/rclone';
    await Dio().download(downloadLink, targetArchiveFile);
    ref.read(rcloneProvider.notifier).endRclone();
    if (!await Directory(backupFolder).exists()) {
      await Directory(backupFolder).create();
    }
    if (await File('$backupFolder/rclone-${state.rcloneCurrentVersion}.exe')
        .exists()) {
      await File('$backupFolder/rclone-${state.rcloneCurrentVersion}.exe')
          .delete();
    }
    await File(currentAlist)
        .rename('$backupFolder/rclone-${state.rcloneCurrentVersion}.exe');
    FileHelper.extractRclone('${state.workDir}/rclonenew.zip', state.workDir);
    await File(targetArchiveFile).delete();
    getRcloneCurrentVersion();
    state = state.copyWith(upgradeStatus: UpgradeStatus.complete);
  }
}
