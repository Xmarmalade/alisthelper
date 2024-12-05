import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/utils/native/auto_start_helper.dart';
import 'package:flutter/material.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  late PersistenceService _persistenceService;

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
      rcloneDirectory: _persistenceService.getRcloneDirectory(),
      themeMode: _persistenceService.getThemeMode(),
      themeColor: _persistenceService.getThemeColor(),
      saveWindowPlacement: _persistenceService.getSaveWindowPlacement(),
      alistArgs: _persistenceService.getAlistArgs(),
      proxy: _persistenceService.getProxy(),
      rcloneArgs: _persistenceService.getRcloneArgs(),
      isFirstRun: _persistenceService.isFirstRun(),
      autoStartRclone: _persistenceService.isAutoStartRclone(),
      startAfterAlist: _persistenceService.isStartAfterAlist(),
      webdavAccount: _persistenceService.getWebdavAccount(),
    );
  }

  Future<void> setWebdavAccount(String value) async {
    await _persistenceService.setWebdavAccount(value);
    state = state.copyWith(webdavAccount: value);
  }

  Future<void> setAutoStartRclone(bool value) async {
    await _persistenceService.setAutoStartRclone(value);
    state = state.copyWith(autoStartRclone: value);
  }

  Future<void> setStartAfterAlist(bool value) async {
    await _persistenceService.setStartAfterAlist(value);
    state = state.copyWith(startAfterAlist: value);
  }

  Future<void> setFirstRun(bool value) async {
    await _persistenceService.setFirstRun(value);
    state = state.copyWith(isFirstRun: value);
  }

  Future<void> setProxy(String? proxy) async {
    await _persistenceService.setProxy(proxy);
    state = state.copyWith(proxy: proxy);
  }

  Future<void> setLocale(AppLocale? locale) async {
    await _persistenceService.setLocale(locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> setAutoStartAlist(bool value) async {
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

  Future<void> setRcloneDirectory(String value) async {
    await _persistenceService.setRcloneDirectory(value);
    state = state.copyWith(rcloneDirectory: value);
  }

  Future<void> setSaveWindowPlacement(bool value) async {
    await _persistenceService.setSaveWindowPlacement(value);
    state = state.copyWith(saveWindowPlacement: value);
  }

  Future<void> setAlistArgs(List<String> value) async {
    await _persistenceService.setAlistArgs(value);
    state = state.copyWith(alistArgs: value);
  }

  Future<void> setRcloneArgs(List<String> value) async {
    await _persistenceService.setRcloneArgs(value);
    state = state.copyWith(rcloneArgs: value);
  }
}
