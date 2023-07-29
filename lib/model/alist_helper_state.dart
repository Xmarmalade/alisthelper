import 'package:freezed_annotation/freezed_annotation.dart';

part 'alist_helper_state.freezed.dart';

@freezed
class AlistHelperState with _$AlistHelperState {
  const factory AlistHelperState({
    @Default('v0.0.0') String currentVersion,
    @Default('v0.0.0') String latestVersion,
    @Default([]) List<Map> newReleaseAssets,
  }) = _AlistHelperState;

}