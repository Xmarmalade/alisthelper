import 'package:alisthelper/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class SettingsState {
  final bool minimizeToTray;
  final bool autoStartLaunchMinimized;
  final bool autoStart;
  final bool autoStartAlist;
  final bool saveWindowPlacement;
  final String workingDirectory;
  final ThemeMode themeMode;
  final Color themeColor;
  final List<String> alistArgs;
  final AppLocale? locale;
  final String? proxy;

  SettingsState({
    required this.minimizeToTray,
    required this.autoStartLaunchMinimized,
    required this.autoStart,
    required this.workingDirectory,
    required this.saveWindowPlacement,
    required this.themeMode,
    required this.themeColor,
    required this.alistArgs,
    required this.autoStartAlist,
    required this.locale,
    required this.proxy,
  });

  SettingsState copyWith({
    bool? minimizeToTray,
    bool? autoStartLaunchMinimized,
    bool? autoStart,
    bool? saveWindowPlacement,
    bool? autoStartAlist,
    String? workingDirectory,
    ThemeMode? themeMode,
    Color? themeColor,
    List<String>? alistArgs,
    AppLocale? locale,
    String? proxy,
  }) {
    return SettingsState(
      autoStartAlist: autoStartAlist ?? this.autoStartAlist,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      autoStartLaunchMinimized:autoStartLaunchMinimized ?? this.autoStartLaunchMinimized,
      autoStart: autoStart ?? this.autoStart,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      saveWindowPlacement: saveWindowPlacement ?? this.saveWindowPlacement,
      alistArgs: alistArgs ?? this.alistArgs,
      locale: locale ?? this.locale,
      proxy: proxy ?? this.proxy,
    );
  }
}
