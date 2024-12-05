import 'package:alisthelper/provider/window_dimensions_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alisthelper/i18n/strings.g.dart';

final persistenceProvider = Provider<PersistenceService>((ref) {
  throw Exception('persistenceProvider not initialized');
});

// Version of the storage
const currentAlistHelperVersion = 'v0.1.5';
const _version = 'ah_current_version';

// App Window Offset and Size info
const _windowOffsetX = 'ah_window_offset_x';
const _windowOffsetY = 'ah_window_offset_y';
const _windowWidth = 'ah_window_width';
const _windowHeight = 'ah_window_height';
const _saveWindowPlacement = 'ah_save_window_placement';

// Settings
const _localeKey = 'ah_locale';
const _autoStartLaunchMinimized = 'ah_auto_start_launch_minimized';
const _minimizeToTray = 'ah_minimize_to_tray';
const _autoStart = 'ah_auto_start';
const _workingDirectory = 'ah_working_directory';
const _themeMode = 'ah_theme_mode';
const _themeColor = 'ah_theme_color';
const _alistArgs = 'ah_alist_args';
const _autoStartAlist = 'ah_auto_start_alist';
const _proxy = 'ah_proxy';
const _rcloneDirectory = 'ah_rclone_directory';
const _rcloneArgs = 'ah_rclone_args';
const _isFirstRun = 'ah_is_first_run';
const _autoStartRclone = 'ah_enable_rclone';
const _startAfterAlist = 'ah_start_after_alist';
const _webdavAccount = 'ah_webdav_account';

/// This service abstracts the persistence layer.
class PersistenceService {
  final SharedPreferences _prefs;

  PersistenceService._(this._prefs);

  static Future<PersistenceService> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Locale configuration upon persistence initialisation to prevent unlocalised Alias generation
    final persistedLocale = prefs.getString(_localeKey);
    if (persistedLocale == null) {
      LocaleSettings.useDeviceLocale();
    } else {
      LocaleSettings.setLocaleRaw(persistedLocale);
    }

    if (prefs.getString(_version) == null ||
        prefs.getString(_version) != currentAlistHelperVersion) {
      await prefs.setString(_version, currentAlistHelperVersion);
    }
    return PersistenceService._(prefs);
  }

  Future<void> setWebdavAccount(String? value) async {
    await _prefs.setString(_webdavAccount, value ?? '');
  }

  String getWebdavAccount() {
    return _prefs.getString(_webdavAccount) ?? '';
  }

  //startAfterAlist
  bool isStartAfterAlist() {
    return _prefs.getBool(_startAfterAlist) ?? false;
  }

  Future<void> setStartAfterAlist(bool value) async {
    await _prefs.setBool(_startAfterAlist, value);
  }

  Future<void> setFirstRun(bool value) async {
    await _prefs.setBool(_isFirstRun, value);
  }

  bool isFirstRun() {
    return _prefs.getBool(_isFirstRun) ?? true;
  }

  String getAlistHelperVersion() {
    return _prefs.getString(_version) ?? currentAlistHelperVersion;
  }

  Future<void> setWindowOffsetX(double x) async {
    await _prefs.setDouble(_windowOffsetX, x);
  }

  Future<void> setWindowOffsetY(double y) async {
    await _prefs.setDouble(_windowOffsetY, y);
  }

  Future<void> setWindowHeight(double height) async {
    await _prefs.setDouble(_windowHeight, height);
  }

  Future<void> setWindowWidth(double width) async {
    await _prefs.setDouble(_windowWidth, width);
  }

  WindowDimensions? getWindowLastDimensions() {
    Size? size;
    Offset? position;
    final offsetX = _prefs.getDouble(_windowOffsetX);
    final offsetY = _prefs.getDouble(_windowOffsetY);
    final width = _prefs.getDouble(_windowWidth);
    final height = _prefs.getDouble(_windowHeight);

    if (width != null && height != null) {
      size = Size(width, height);
    }

    if (offsetX != null && offsetY != null) {
      if (offsetX < -2048 || offsetY < -2048) {
        position = const Offset(0, 0);
      }
      position = Offset(offsetX, offsetY);
    }

    if (size == null || position == null) {
      return null;
    }

    return WindowDimensions(
      position: position,
      size: size,
    );
  }

  Future<void> setSaveWindowPlacement(bool savePlacement) async {
    await _prefs.setBool(_saveWindowPlacement, savePlacement);
  }

  bool getSaveWindowPlacement() {
    return _prefs.getBool(_saveWindowPlacement) ?? true;
  }

  bool isMinimizeToTray() {
    return _prefs.getBool(_minimizeToTray) ?? true;
  }

  Future<void> setMinimizeToTray(bool minimizeToTray) async {
    await _prefs.setBool(_minimizeToTray, minimizeToTray);
  }

  bool isAutoStartLaunchMinimized() {
    return _prefs.getBool(_autoStartLaunchMinimized) ?? true;
  }

  Future<void> setAutoStartLaunchMinimized(bool launchMinimized) async {
    await _prefs.setBool(_autoStartLaunchMinimized, launchMinimized);
  }

  String getWorkingDirectory() {
    return _prefs.getString(_workingDirectory) ?? r'';
  }

  Future<void> setWorkingDirectory(String path) async {
    await _prefs.setString(_workingDirectory, path);
  }

  String getRcloneDirectory() {
    return _prefs.getString(_rcloneDirectory) ?? r'';
  }

  Future<void> setRcloneDirectory(String path) async {
    await _prefs.setString(_rcloneDirectory, path);
  }

  Future<void> setRcloneArgs(List<String> value) async {
    await _prefs.setStringList(_rcloneArgs, value);
  }

  List<String> getRcloneArgs() {
    return _prefs.getStringList(_rcloneArgs) ?? ['rcd', '--rc-web-gui'];
  }

  Future<void> setAutoStartRclone(bool value) async {
    await _prefs.setBool(_autoStartRclone, value);
  }

  bool isAutoStartRclone() {
    return _prefs.getBool(_autoStartRclone) ?? false;
  }

  bool isAutoStart() {
    return _prefs.getBool(_autoStart) ?? false;
  }

  Future<void> setAutoStart(bool autoStart) async {
    await _prefs.setBool(_autoStart, autoStart);
  }

  ThemeMode getThemeMode() {
    final themeModeIndex = _prefs.getInt(_themeMode);
    if (themeModeIndex == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[themeModeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(_themeMode, themeMode.index);
  }

  Color getThemeColor() {
    return _prefs.getInt(_themeColor) == null
        ? Colors.cyan
        : Color(_prefs.getInt(_themeColor)!);
  }

  Future<void> setThemeColor(Color themeColor) async {
    await _prefs.setInt(_themeColor, themeColor.value);
  }

  AppLocale? getLocale() {
    final value = _prefs.getString(_localeKey);
    if (value == null) {
      return null;
    }
    return AppLocale.values
        .firstWhereOrNull((locale) => locale.languageTag == value);
  }

  Future<void> setLocale(AppLocale? locale) async {
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageTag);
    }
  }

  List<String> getAlistArgs() {
    return _prefs.getStringList(_alistArgs) ?? ['server'];
  }

  Future<void> setAlistArgs(List<String> args) async {
    await _prefs.setStringList(_alistArgs, args);
  }

  bool isAutoStartAlist() {
    return _prefs.getBool(_autoStartAlist) ?? false;
  }

  Future<void> setAutoStartAlist(bool autoStart) async {
    await _prefs.setBool(_autoStartAlist, autoStart);
  }

  String getProxy() {
    return _prefs.getString(_proxy) ?? '';
  }

  Future<void> setProxy(String? proxy) async {
    await _prefs.setString(_proxy, proxy ?? '');
  }
}
