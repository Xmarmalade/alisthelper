import 'dart:io';

import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/app_arguments_provider.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/theme.dart';
import 'package:alisthelper/utils/init.dart';
import 'package:alisthelper/utils/native/tray_helper.dart';
import 'package:alisthelper/utils/native/tray_manager.dart';
import 'package:alisthelper/utils/native/window_watcher.dart';
import 'package:alisthelper/widgets/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> main(List<String> args) async {

  final persistenceService = await preInit(args);
  
  runApp(ProviderScope(overrides: [
    persistenceProvider.overrideWithValue(persistenceService),
    appArgumentsProvider.overrideWith((ref) => args),
  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alistNotifier = ref.read(alistProvider.notifier);
    Color color = ref.watch(settingsProvider.select((settings) => settings.themeColor));
    return TrayWatcher(
      child: WindowWatcher(
        onClose: () async {
          try {
            if (ref.read(settingsProvider).minimizeToTray) {
              await hideToTray();
            } else {
              alistNotifier.endAlist();
              exit(0);
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: MaterialApp(
          title: 'Alist Helper',
          themeMode: ref.watch(settingsProvider.select((settings) => settings.themeMode)),
          theme: AlistHelperTheme(color)
              .lightThemeData,
          darkTheme: AlistHelperTheme(color)
              .darkThemeData,
          home: const Home(),
        ),
      ),
    );
  }
}
