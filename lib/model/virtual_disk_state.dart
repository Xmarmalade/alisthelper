import 'package:freezed_annotation/freezed_annotation.dart';

part 'virtual_disk_state.freezed.dart';
part 'virtual_disk_state.g.dart';

@freezed
class VirtualDiskState with _$VirtualDiskState {
  const factory VirtualDiskState({
    @Default(false) bool isMounted,
    @Default([]) List<String> extraFlags,
    @Default('T') String mountPoint,
    @Default('name') String name,
    @Default('vendor') String vendor,
    @Default('path') String path,
    @Default(false) bool autoMount,
  }) = _VirtualDiskState;

  factory VirtualDiskState.fromJson(Map<String, dynamic> json) =>
      _$VirtualDiskStateFromJson(json);
}
