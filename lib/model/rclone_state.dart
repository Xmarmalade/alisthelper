import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'rclone_state.freezed.dart';

@freezed
class RcloneState with _$RcloneState{
  const factory RcloneState({
    @Default(false) bool isRunning,
    @Default([]) List<String> output,
    @Default('') String arg,
    int? pid,
    Process? process,
  }) = _RcloneState;

  factory RcloneState.fromString(String arg) => RcloneState(arg: arg);
}