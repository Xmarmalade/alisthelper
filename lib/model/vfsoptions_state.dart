// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'vfsoptions_state.freezed.dart';
part 'vfsoptions_state.g.dart';

@freezed
abstract class VfsOptions with _$VfsOptions {
  const factory VfsOptions({
    @Default(3600000000000) int CacheMaxAge,
    @Default(10737418240) int CacheMaxSize,
    @Default('writes') String CacheMode,
    @Default(60000000000) int CachePollInterval,
    @Default(false) bool CaseInsensitive,
    @Default(67108864) int ChunkSize,
    @Default(-1) int ChunkSizeLimit,
    @Default(300000000000) int DirCacheTime,
    @Default(511) int DirPerms,
    @Default(511) int FilePerms,
    @Default(4294967295) int GID,
    @Default(false) bool NoChecksum,
    @Default(false) bool NoModTime,
    @Default(false) bool NoSeek,
    @Default(60000000000) int PollInterval,
    @Default(0) int ReadAhead,
    @Default(false) bool ReadOnly,
    @Default(20000000) int ReadWait,
    @Default(4294967295) int UID,
    @Default(0) int Umask,
    @Default(5000000000) int WriteBack,
    @Default(1000000000) int WriteWait,
    @Default(false) bool Refresh,
    @Default(false) bool BlockNormDupes,
    @Default(false) bool UsedIsSize,
    @Default(false) bool FastFingerprint,
    @Default(-1) int DiskSpaceTotalSize,
  }) = _VfsOptions;

  factory VfsOptions.fromJson(Map<String, dynamic> json) =>
      _$VfsOptionsFromJson(json);
}
