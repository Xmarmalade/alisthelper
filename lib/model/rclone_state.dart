import 'dart:io';

import 'package:alisthelper/model/virtual_disk_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rclone_state.freezed.dart';

@freezed
class RcloneState with _$RcloneState {
  const factory RcloneState({
    @Default(false) bool isRunning,
    @Default([]) List<String> output,
    @Default([]) List<String> arg,
    @Default('http://localhost:5572') String url,
    @Default([]) List<VirtualDiskState> vdList,
    @Default('') String webdavAccount,
    @Default([]) List<String> remoteList,
    int? pid,
    Process? process,
  }) = _RcloneState;
}
