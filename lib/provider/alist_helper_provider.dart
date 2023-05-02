import 'dart:async';
import 'dart:convert';

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
    Future(() => state = state.copyWith(currentVersion: currentAlistHelperVersion));
    
  }

  Future<void> fetchAlistHelperLatestVersion() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/iiijam/alisthelper/releases/latest'));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final latest = json['tag_name'] as String;
    state = state.copyWith(latestVersion: latest);
    print('Latest release: $latest');
  }
}

class AlistHelperState {
  final String currentVersion;
  final String latestVersion;

  AlistHelperState(
      {this.currentVersion = 'v0.0.0', this.latestVersion = 'v0.0.0'});

  AlistHelperState copyWith({String? currentVersion, String? latestVersion}) {
    return AlistHelperState(
        currentVersion: currentVersion ?? this.currentVersion,
        latestVersion: latestVersion ?? this.latestVersion);
  }
}
