import 'package:freezed_annotation/freezed_annotation.dart';

part 'alist_state.freezed.dart';

@freezed
class AlistState with _$AlistState {
  const factory AlistState({
    @Default(false) bool isRunning,
    @Default([]) List<String> output,
    @Default('http://localhost:5244') String url,
    @Default('v1.0.0') String currentVersion,
    @Default('v1.0.0') String latestVersion,
    @Default([]) List<Map> newReleaseAssets,
    @Default('') String workDir,
    @Default([]) List<String> alistArgs,
    @Default('') String proxy,
    @Default(UpgradeStatus.idle) UpgradeStatus upgradeStatus,
  }) = _AlistState;
}

enum UpgradeStatus {
  idle,
  installing,
  complete,
}
