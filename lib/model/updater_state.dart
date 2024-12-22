import 'package:freezed_annotation/freezed_annotation.dart';

part 'updater_state.freezed.dart';

@freezed
class UpdaterState with _$UpdaterState {
  const factory UpdaterState({
    @Default('v1.0.0') String rcloneCurrentVersion,
    @Default('v1.0.0') String rcloneLatestVersion,
    @Default([]) List<Map> rcloneAssets,
    @Default('') String rcloneDirectory,
    @Default(UpgradeStatus.idle) UpgradeStatus upgradeStatus,
  }) = _UpdaterState;
}

enum UpgradeStatus {
  idle,
  installing,
  complete,
}
