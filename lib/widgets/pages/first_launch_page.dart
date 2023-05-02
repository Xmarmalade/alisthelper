import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/widgets/pages/about_page.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';

import 'package:alisthelper/widgets/theme_tile.dart';
import 'package:alisthelper/widgets/working_directory_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstLaunchPage extends StatelessWidget {
  const FirstLaunchPage({super.key, required this.sizingInformation});
  final SizingInformation sizingInformation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (sizingInformation.isDesktop
            ? null
            : AppBar(
                title: const Text('Hi!',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        body: const IntroTab());
  }
}

class IntroTab extends ConsumerStatefulWidget {
  const IntroTab({super.key});

  @override
  ConsumerState<IntroTab> createState() => _IntroTabState();
}

class _IntroTabState extends ConsumerState<IntroTab> {
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
                  title: Text(
                      'Welcome to use Alist Helper, let\'s get started!',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text(
                      'Click here to learn more about Alist Helper!'),
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
            Card(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(children: [
                const ListTile(
                    title: Text(
                        'First, let\'s choose your preferred theme here!',
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
                    title: Text(
                        'Second, you have to get an alist and tell the alist helper where it is!',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18))),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title:
                      const Text('If you don\'t have alist yet, get it here!'),
                  onTap: () async {
                    await launchUrl(
                        Uri.parse(
                            'https://alist.nn.ci/zh/guide/install/manual.html'),
                        mode: LaunchMode.externalApplication);
                  },
                ),
                WorkingDirectoryTile(
                    settings: settings, settingsNotifier: settingsNotifier),
                //Container(height: 10)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
