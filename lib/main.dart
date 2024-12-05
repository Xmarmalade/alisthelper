import 'dart:io';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/app_arguments_provider.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/theme.dart';
import 'package:alisthelper/utils/init.dart';
import 'package:alisthelper/utils/native/tray_helper.dart';
import 'package:alisthelper/utils/native/tray_manager.dart';
import 'package:alisthelper/utils/native/window_watcher.dart';
import 'package:alisthelper/widgets/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main(List<String> args) async {
  final persistenceService = await preInit(args);

  runApp(ProviderScope(overrides: [
    persistenceProvider.overrideWithValue(persistenceService),
    appArgumentsProvider.overrideWith((ref) => args),
  ], child: TranslationProvider(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final alistNotifier = ref.read(alistProvider.notifier);
    Color color = settings.themeColor;
    final rcloneNotifier = ref.read(rcloneProvider.notifier);
    return TrayWatcher(
      child: WindowWatcher(
        onClose: () async {
          try {
            if (ref.read(settingsProvider).minimizeToTray) {
              await hideToTray();
            } else {
              await alistNotifier.endAlist();
              await rcloneNotifier.endRclone();
              exit(0);
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: MaterialApp(
          title: 'Alist Helper',
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          themeMode: settings.themeMode,
          theme: AlistHelperTheme(color).lightThemeData,
          darkTheme: AlistHelperTheme(color).darkThemeData,
          home: const Home(),
        ),
      ),
    );
  }
}
