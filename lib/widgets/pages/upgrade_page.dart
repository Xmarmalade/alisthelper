import 'package:alisthelper/i18n/strings.g.dart';
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
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.upgrade.upgrade,
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    ListTile(
                      title: Text(t.upgrade.alistVersion.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                        title: Text(t.upgrade.alistVersion.currentVersion),
                        subtitle: Consumer(
                          builder: (context, watch, child) {
                            return Text(alistState.currentVersion);
                          },
                        )),
                    ListTile(
                      title: Text(t.upgrade.alistVersion.latestVersion),
                      subtitle: Text((alistState.latestVersion == 'v1.0.0')
                          ? t.upgrade.clickToCheck
                          : alistState.latestVersion),
                      onTap: () async {
                        try {
                          await alistNotifier.fetchLatestVersion();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: Text(t.upgrade.upgrade),
                      subtitle: Text(
                        (alistState.latestVersion == 'v1.0.0'
                            ? t.upgrade.checkFirst
                            : (TextUtils.isNewVersion(alistState.currentVersion,
                                    alistState.latestVersion)
                                ? t.upgrade.canUpgrade
                                : t.upgrade.noUpgrade)),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/alist-org/alist/releases/latest'));
                        },
                        child: Text(t.button.upgrade),
                      ),
                    ),
                    Container(height: 10)
                  ]),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    ListTile(
                      title: Text(t.upgrade.alistHelperVersion.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                        title:
                            Text(t.upgrade.alistHelperVersion.currentVersion),
                        subtitle: Consumer(
                          builder: (context, watch, child) {
                            //alistHelperNotifier.getAlistHelperCurrentVersion();
                            return Text(alistHelperState.currentVersion);
                          },
                        )),
                    ListTile(
                      title: Text(t.upgrade.alistHelperVersion.latestVersion),
                      subtitle: Text(
                          (alistHelperState.latestVersion == 'v0.0.0')
                              ? t.upgrade.clickToCheck
                              : alistHelperState.latestVersion),
                      onTap: () async {
                        try {
                          await alistHelperNotifier
                              .fetchAlistHelperLatestVersion();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: Text(t.upgrade.upgrade),
                      subtitle: Text(
                        (alistHelperState.latestVersion == 'v0.0.0'
                            ? t.upgrade.checkFirst
                            : (TextUtils.isNewVersion(
                                    alistHelperState.currentVersion,
                                    alistHelperState.latestVersion)
                                ? t.upgrade.canUpgrade
                                : t.upgrade.noUpgrade)),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/Xmarmalade/alisthelper/releases/latest'));
                        },
                        child: Text(t.button.upgrade),
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
