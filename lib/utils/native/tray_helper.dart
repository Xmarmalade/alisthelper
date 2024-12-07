import 'dart:io';
import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart' as tm;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

enum TrayEntry {
  open,
  quit,
  hide,
  endAlist,
  startAlist,
  openGUI,
}

Future<void> initTray() async {
  if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) {
    return;
  }
  String iconPath =
      Platform.isWindows ? 'assets/alisthelper.ico' : 'assets/alisthelper.png';
  await tm.trayManager.setIcon(iconPath);

  final items = [
    tm.MenuItem(key: TrayEntry.open.name, label: t.tray.open),
    tm.MenuItem(key: TrayEntry.hide.name, label: t.tray.hide),
    tm.MenuItem(key: TrayEntry.quit.name, label: t.tray.quit),
  ];
  await tm.trayManager.setContextMenu(tm.Menu(items: items));
  await tm.trayManager.setToolTip(t.tray.tooltip);
}

Future<void> changeTray(bool isRunning) async {
  final items = [
    tm.MenuItem(key: TrayEntry.open.name, label: t.tray.open),
    tm.MenuItem(key: TrayEntry.hide.name, label: t.tray.hide),
    tm.MenuItem(key: TrayEntry.quit.name, label: t.tray.quit),
  ];
  if (isRunning) {
    //add endAlist
    items.insert(
        1, tm.MenuItem(key: TrayEntry.endAlist.name, label: t.tray.endAlist));
    items.insert(
        2, tm.MenuItem(key: TrayEntry.openGUI.name, label: t.tray.openGUI));
    tm.trayManager.setContextMenu(tm.Menu(items: items));
    await tm.trayManager.setToolTip(t.tray.workingTooltip);
  } else {
    //add startAlist
    items.insert(1,
        tm.MenuItem(key: TrayEntry.startAlist.name, label: t.tray.startAlist));
    tm.trayManager.setContextMenu(tm.Menu(items: items));
    await tm.trayManager.setToolTip(t.tray.tooltip);
  }
}

Future<void> hideToTray() async {
  await windowManager.hide();
  if (Platform.isMacOS) {
    // This will crash on Windows
    // https://github.com/localsend/localsend/issues/32
    await windowManager.setSkipTaskbar(true);
  }
}

Future<void> showFromTray() async {
  await windowManager.show();
  await windowManager.focus();
  if (Platform.isMacOS) {
    // This will crash on Windows
    // https://github.com/localsend/localsend/issues/32
    await windowManager.setSkipTaskbar(false);
  }
}

Future<void> startAlist(WidgetRef ref) async {
  final alistNotifier = ref.watch(alistProvider.notifier);
  alistNotifier.startAlist();
}

Future<void> endAlist(WidgetRef ref) async {
  final alistNotifier = ref.watch(alistProvider.notifier);
  alistNotifier.endAlist();
}

Future<void> openGUI(WidgetRef ref) async {
  final alistState = ref.watch(alistProvider);
  final Uri url = Uri.parse(alistState.url);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch the $url');
  }
}
