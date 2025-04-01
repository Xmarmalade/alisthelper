import 'package:alisthelper/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool minimizeToTray,
    required bool autoStartLaunchMinimized,
    required bool autoStart,
    required bool autoStartAlist,
    required bool saveWindowPlacement,
    required String workingDirectory,
    required String rcloneDirectory,
    required ThemeMode themeMode,
    required Color themeColor,
    required List<String> alistArgs,
    required AppLocale? locale,
    required String? proxy,
    required List<String> rcloneArgs,
    required bool isFirstRun,
    required bool autoStartRclone,
    required bool startAfterAlist,
    required String webdavAccount,
  }) = _SettingsState;
}
