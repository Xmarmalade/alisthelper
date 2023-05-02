import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/widgets/alist_args_tile.dart';
import 'package:alisthelper/widgets/pages/about_page.dart';
import 'package:alisthelper/widgets/pages/upgrade_page.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';
import 'package:alisthelper/widgets/theme_tile.dart';
import 'package:alisthelper/widgets/toggle_tile.dart';
import 'package:alisthelper/widgets/working_directory_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.sizingInformation});
  final SizingInformation sizingInformation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (sizingInformation.isDesktop
            ? null
            : AppBar(
                title: const Text('Settings',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        body: const SettingsTab());
  }
}

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  @override
  void initState() {
    super.initState();
    //final settings = ref.read(settingsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(children: [
                const ListTile(
                    title: Text('Interface',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18))),
                ChangeThemeModeTile(
                    settings: settings, settingsNotifier: settingsNotifier),
                ChangeThemeColorTile(
                    settings: settings, settingsNotifier: settingsNotifier),
                Container(height: 10)
              ]),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(children: [
                const ListTile(
                    title: Text('Options',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18))),
                CustomToggleTile(
                  value: settings.saveWindowPlacement,
                  onToggled: (value) => ref
                      .read(settingsProvider.notifier)
                      .setSaveWindowPlacement(value),
                  title: 'Save AlistHelper window placement',
                  subtitle: 'This will allow AlistHelper save window placement',
                ),
                CustomToggleTile(
                  value: settings.minimizeToTray,
                  onToggled: (value) => ref
                      .read(settingsProvider.notifier)
                      .setMinimizeToTray(value),
                  title: 'Allow AlistHelper minimize to tray',
                  subtitle: 'This will allow AlistHelper to minimize to tray',
                ),
                CustomToggleTile(
                  value: settings.autoStart,
                  onToggled: (value) =>
                      ref.read(settingsProvider.notifier).setAutoStart(value),
                  title: 'Allow auto start',
                  subtitle: 'This will allow AlistHelper auto start',
                ),
                CustomToggleTile(
                  value: settings.autoStartLaunchMinimized,
                  onToggled: (value) => ref
                      .read(settingsProvider.notifier)
                      .setAutoStartLaunchMinimized(value),
                  title: 'Allow silent auto start',
                  subtitle: 'This will allow AlistHelper auto start silently',
                ),
                Container(height: 10)
              ]),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(children: [
                const ListTile(
                    title: Text('Alist',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18))),
                CustomToggleTile(
                  value: settings.autoStartAlist,
                  onToggled: (value) => ref
                      .read(settingsProvider.notifier)
                      .setAutoStartAList(value),
                  title: 'Allow alist auto start',
                  subtitle:
                      'This will auto start alist when AlistHelper starts',
                ),
                WorkingDirectoryTile(
                    settings: settings, settingsNotifier: settingsNotifier),
                AlistArgsTile(
                    settings: settings, settingsNotifier: settingsNotifier),
                Container(height: 10)
              ]),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(children: [
                const ListTile(
                  title: Text('Others',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                ListTile(
                    title: const Text('Check for updates (NOT IMPLEMENTED)'),onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpgradePage()));
                  },),
                ListTile(
                  title: const Text('About us'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()));
                  },
                ),
                Container(height: 10)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}