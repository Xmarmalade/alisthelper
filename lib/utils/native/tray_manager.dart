import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tray_helper.dart';

class TrayWatcher extends ConsumerStatefulWidget {
  final Widget child;

  const TrayWatcher({required this.child, super.key});

  @override
  ConsumerState<TrayWatcher> createState() => _TrayWatcherState();
}

class _TrayWatcherState extends ConsumerState<TrayWatcher> with TrayListener {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() async {
    if (Platform.isMacOS) {
      await trayManager.popUpContextMenu();
    } else {
      await showFromTray();
    }
  }

  @override
  void onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    final entry =
        TrayEntry.values.firstWhereOrNull((e) => e.name == menuItem.key);
    switch (entry) {
      case TrayEntry.open:
        await showFromTray();
        break;
      case TrayEntry.quit:
        await AlistNotifier.endAlistProcess();
        await RcloneNotifier.endRcloneProcess();
        exit(0);
      case TrayEntry.startAlist:
        await startAlist(ref);
        break;
      case TrayEntry.endAlist:
        await endAlist(ref);
        break;
      case TrayEntry.hide:
        await hideToTray();
        break;
      default:
    }
  }
}
