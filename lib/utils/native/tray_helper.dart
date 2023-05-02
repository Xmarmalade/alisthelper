import 'dart:io';
import 'package:tray_manager/tray_manager.dart' as tm;
import 'package:window_manager/window_manager.dart';

enum TrayEntry {
  open,
  close,
  hide,
}

Future<void> initTray() async {
  if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) {
    return;
  }
  String iconPath =
      Platform.isWindows ? 'assets/alisthelper.ico' : 'assets/alisthelper.png';
  await tm.trayManager.setIcon(iconPath);

  final items = [
    tm.MenuItem(
      key: TrayEntry.open.name,
      label: 'Open',
    ),
    tm.MenuItem(
      key: TrayEntry.hide.name,
      label: 'Hide',
    ),
    tm.MenuItem(
      key: TrayEntry.close.name,
      label: 'Quit',
    ),
  ];
  await tm.trayManager.setContextMenu(tm.Menu(items: items));
  await tm.trayManager.setToolTip('Alist Helper');
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
