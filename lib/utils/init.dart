import 'dart:io';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_helper_provider.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/persistence_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/provider/window_dimensions_provider.dart';
import 'package:alisthelper/utils/native/tray_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

/// Pre-initializes the app.
/// Reads the command line arguments and initializes the [PersistenceService].
/// Initializes the tray and the window manager.
Future<PersistenceService> preInit(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistenceService = await PersistenceService.initialize();

  // Register default plural resolver
  for (final locale in AppLocale.values) {
    if ([AppLocale.en, AppLocale.zhHansCn, AppLocale.zhHantTw]
        .contains(locale)) {
      continue;
    }

    await LocaleSettings.setPluralResolver(
      locale: locale,
      cardinalResolver: (n, {zero, one, two, few, many, other}) {
        if (n == 0) {
          return zero ?? other ?? n.toString();
        }
        if (n == 1) {
          return one ?? other ?? n.toString();
        }
        return other ?? n.toString();
      },
      ordinalResolver: (n, {zero, one, two, few, many, other}) {
        return other ?? n.toString();
      },
    );
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Check if this app is already open and let it "show up".
    // If this is the case, then exit the current instance.
    // initialize tray AFTER i18n has been initialized
    try {
      await initTray();
    } catch (e) {
      debugPrint('Initializing tray failed: $e');
    }

    // initialize size and position
    await WindowManager.instance.ensureInitialized();
    await WindowDimensionsController(persistenceService)
        .initDimensionsConfiguration();

    //

    //If the app is launched with the autostart argument, it will not be minimized by default.
    //https://github.com/leanflutter/window_manager#hidden-at-launch
    bool isAutoStart = args.contains('autostart');
    bool isAutoStartLaunchMinimized =
        persistenceService.isAutoStartLaunchMinimized();
    if (!isAutoStart || !isAutoStartLaunchMinimized) {
      await WindowManager.instance.show();
    }
    if (isAutoStartLaunchMinimized && Platform.isMacOS) {
      await hideToTray();
    }
  }
  return persistenceService;
}

/// Post-initializes the app.
/// Starts the Alist if the [Settings.autoStartAlist] is true.
Future<void> postInit(WidgetRef ref) async {
  final alistNotifier = ref.watch(alistProvider.notifier);
  if (!ref.watch(settingsProvider).isFirstRun) {
    alistNotifier.getAlistCurrentVersion(addToOutput: false);
  }
  final alistHelperNotifier = ref.watch(ahProvider.notifier);
  alistHelperNotifier.getAlistHelperCurrentVersion();

  if (ref.watch(settingsProvider).autoStartAlist &&
      !ref.watch(alistProvider).isRunning) {
    var alistNotifier = ref.watch(alistProvider.notifier);
    alistNotifier.startAlist();
  }

  if (ref.watch(settingsProvider).autoStartRclone) {
    if (ref.watch(settingsProvider).startAfterAlist) {
      //wait 3 second
      await Future.delayed(const Duration(seconds: 3));
      if (ref.watch(alistProvider).isRunning) {
        var rcloneNotifier = ref.watch(rcloneProvider.notifier);
        rcloneNotifier.startRclone();
      }
    } else {
      var rcloneNotifier = ref.watch(rcloneProvider.notifier);
      rcloneNotifier.startRclone();
    }
  }
}
