import 'package:alisthelper/provider/alist_helper_provider.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradePage extends ConsumerStatefulWidget {
  const UpgradePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpgradePageState();
}

class _UpgradePageState extends ConsumerState<UpgradePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final alistNotifier = ref.read(alistProvider.notifier);
        alistNotifier.getAlistCurrentVersion(addToOutput: false);
        final alistHelperNotifier = ref.read(alistHelperProvider.notifier);
        alistHelperNotifier.getAlistHelperCurrentVersion();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alistNotifier = ref.read(alistProvider.notifier);
    final alistState = ref.watch(alistProvider);
    final alistHelperNotifier = ref.read(alistHelperProvider.notifier);
    final alistHelperState = ref.watch(alistHelperProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    const ListTile(
                      title: Text('Alist Version',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                        title: const Text('Current Alist Version'),
                        subtitle: Consumer(
                          builder: (context, watch, child) {
                            return Text(alistState.currentVersion);
                          },
                        )),
                    ListTile(
                      title: const Text('Latest Alist Version'),
                      subtitle: Text((alistState.latestVersion == 'v1.0.0')
                          ? 'Chick me to check'
                          : alistState.latestVersion),
                      onTap: () async {
                        try {
                          await alistNotifier.fetchLatestVersion();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Upgrade Alist'),
                      subtitle: Text(
                        (alistState.latestVersion == 'v1.0.0'
                            ? 'Check first'
                            : (TextUtils.isNewVersion(alistState.currentVersion,
                                    alistState.latestVersion)
                                ? 'You can upgrade now'
                                : 'You are using the latest alist')),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/alist-org/alist/releases/latest'));
                        },
                        child: const Text('Upgrade'),
                      ),
                    ),
                    Container(height: 10)
                  ]),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    const ListTile(
                      title: Text('Alist Helper Version',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                        title: const Text('Current Alist Helper Version'),
                        subtitle: Consumer(
                          builder: (context, watch, child) {
                            //alistHelperNotifier.getAlistHelperCurrentVersion();
                            return Text(alistHelperState.currentVersion);
                          },
                        )),
                    ListTile(
                      title: const Text('Latest Alist Helper Version'),
                      subtitle: Text(
                          (alistHelperState.latestVersion == 'v0.0.0')
                              ? 'Chick me to check'
                              : alistHelperState.latestVersion),
                      onTap: () async {
                        try {
                          await alistHelperNotifier
                              .fetchAlistHelperLatestVersion();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Upgrade Alist Helper'),
                      subtitle: Text(
                        (alistHelperState.latestVersion == 'v0.0.0'
                            ? 'Check first'
                            : (TextUtils.isNewVersion(
                                    alistHelperState.currentVersion,
                                    alistHelperState.latestVersion)
                                ? 'You can upgrade now'
                                : 'You are using the latest alist helper')),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/iiijam/alisthelper/releases/latest'));
                        },
                        child: const Text('Upgrade'),
                      ),
                    ),
                    Container(height: 10)
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
