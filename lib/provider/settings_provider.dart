import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/utils/native/auto_start_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/persistence_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsState> {
  late PersistenceService _persistenceService;

  SettingsNotifier();

  @override
  SettingsState build() {
    _persistenceService = ref.watch(persistenceProvider);
    return SettingsState(
      locale: _persistenceService.getLocale(),
      autoStartAlist: _persistenceService.isAutoStartAlist(),
      minimizeToTray: _persistenceService.isMinimizeToTray(),
      autoStartLaunchMinimized:
          _persistenceService.isAutoStartLaunchMinimized(),
      autoStart: _persistenceService.isAutoStart(),
      workingDirectory: _persistenceService.getWorkingDirectory(),
      themeMode: _persistenceService.getThemeMode(),
      themeColor: _persistenceService.getThemeColor(),
      saveWindowPlacement: _persistenceService.getSaveWindowPlacement(),
      alistArgs: _persistenceService.getAlistArgs(),
    );
  }

  Future<void> setLocale(AppLocale? locale) async {
    await _persistenceService.setLocale(locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> setAutoStartAList(bool value) async {
    await _persistenceService.setAutoStartAlist(value);
    state = state.copyWith(autoStartAlist: value);
  }

  Future<void> setThemeColor(Color value) async {
    await _persistenceService.setThemeColor(value);
    state = state.copyWith(themeColor: value);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    await _persistenceService.setThemeMode(value);
    state = state.copyWith(themeMode: value);
  }

  Future<void> setMinimizeToTray(bool value) async {
    await _persistenceService.setMinimizeToTray(value);
    state = state.copyWith(minimizeToTray: value);
  }

  Future<void> setAutoStartLaunchMinimized(bool value) async {
    await _persistenceService.setAutoStartLaunchMinimized(value);
    state = state.copyWith(autoStartLaunchMinimized: value);
  }

  Future<void> setAutoStart(bool value) async {
    await _persistenceService.setAutoStart(value);
    initAutoStartAndOpenSettings(value);
    state = state.copyWith(autoStart: value);
  }

  Future<void> setWorkingDirectory(String value) async {
    await _persistenceService.setWorkingDirectory(value);
    state = state.copyWith(workingDirectory: value);
  }

  Future<void> setSaveWindowPlacement(bool value) async {
    await _persistenceService.setSaveWindowPlacement(value);
    state = state.copyWith(saveWindowPlacement: value);
  }

  Future<void> setAlistArgs(List<String> value) async {
    await _persistenceService.setAlistArgs(value);
    state = state.copyWith(alistArgs: value);
  }
}
