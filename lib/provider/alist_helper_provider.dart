import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alisthelper/model/alist_helper_state.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ahProvider = NotifierProvider<AlistHelperNotifier, AlistHelperState>(
    AlistHelperNotifier.new);

class AlistHelperNotifier extends Notifier<AlistHelperState> {
  late PersistenceService _persistenceService;
  late String currentAlistHelperVersion;

  @override
  AlistHelperState build() {
    _persistenceService = ref.watch(persistenceProvider);
    currentAlistHelperVersion = _persistenceService.getAlistHelperVersion();
    return const AlistHelperState();
  }

  // Get alist version
  Future<void> getAlistHelperCurrentVersion() async {
    state = state.copyWith(currentVersion: currentAlistHelperVersion);
  }

  Future<void> fetchAlistHelperLatestVersion() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/Xmarmalade/alisthelper/releases/latest'));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    try {
      String latest = json['tag_name'];
      List assets = json['assets'];
      String platformKey = Platform.isWindows
          ? 'windows'
          : (Platform.isMacOS ? 'macos' : 'linux');
      List<Map> assetsForSpecificPlatform = [];
      for (Map asset in assets) {
        if (asset['name'].contains(platformKey)) {
          assetsForSpecificPlatform.add(asset);
        }
      }
      state = state.copyWith(
          latestVersion: latest, newReleaseAssets: assetsForSpecificPlatform);
    } catch (e) {
      throw Exception(
          '$e\nFailed to get latest version when fetching: ${json.toString()}');
    }
  }
}
