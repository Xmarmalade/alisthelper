import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final alistHelperProvider =
    StateNotifierProvider<AlistHelperNotifier, AlistHelperState>((ref) {
  PersistenceService persistenceService = ref.watch(persistenceProvider);
  String currentAlistHelperVersion = persistenceService.getAlistHelperVersion();

  return AlistHelperNotifier(currentAlistHelperVersion);
});

class AlistHelperNotifier extends StateNotifier<AlistHelperState> {
  AlistHelperNotifier(this.currentAlistHelperVersion)
      : super(AlistHelperState());

  String currentAlistHelperVersion;

  //get alist version
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
          'Failed to get latest version when fetching: $json \n Error is: $e');
    }
    //print('Latest release: ${state.newReleaseAssets}');
  }
}

class AlistHelperState {
  final String currentVersion;
  final String latestVersion;
  final List<Map> newReleaseAssets;

  AlistHelperState({
    this.currentVersion = 'v0.0.0',
    this.latestVersion = 'v0.0.0',
    this.newReleaseAssets = const [],
  });

  AlistHelperState copyWith({
    String? currentVersion,
    String? latestVersion,
    List<Map>? newReleaseAssets,
  }) {
    return AlistHelperState(
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion ?? this.latestVersion,
      newReleaseAssets: newReleaseAssets ?? this.newReleaseAssets,
    );
  }
}
