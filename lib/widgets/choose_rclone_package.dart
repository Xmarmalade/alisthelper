import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/model/updater_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/provider/updater_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseRclonePackage extends ConsumerStatefulWidget {
  final bool isUpgrade;
  const ChooseRclonePackage({super.key, required this.isUpgrade});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseRclonePackageState();
}

class _ChooseRclonePackageState extends ConsumerState<ChooseRclonePackage> {
  @override
  Widget build(BuildContext context) {
    final updaterState = ref.watch(updaterProvider);
    final updaterNotifier = ref.watch(updaterProvider.notifier);

    final SettingsState settingsState = ref.watch(settingsProvider);
    try {
      if (updaterState.rcloneAssets.isEmpty) {
        updaterNotifier.fetchLatestVersion();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    return AlertDialog(
        title: Text(t.upgrade.selectPackage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ListTile(
                title: widget.isUpgrade
                    ? Text(
                        'Will be upgrade from: ${settingsState.rcloneDirectory}')
                    : Text(
                        'Will be installed to: ${settingsState.rcloneDirectory}'),
              ),
            ),
            Center(
              child: updaterState.upgradeStatus == UpgradeStatus.installing
                  ? const LinearProgressIndicator()
                  : updaterState.upgradeStatus == UpgradeStatus.complete
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 30,
                          margin: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              'Installation complete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
            ),
            SizedBox(
                width: double.maxFinite,
                height: 200,
                child: (updaterState.rcloneAssets.isEmpty)
                    ? Center(child: Text(t.upgrade.networkError))
                    : ListView(
                        children: updaterState.rcloneAssets.map((asset) {
                          return ListTile(
                            title: Text(asset['name']),
                            leading: const Icon(Icons.grid_view_outlined),
                            subtitle: Text(
                                '${(asset['size'] / 1000000).toStringAsFixed(2)} MB'),
                            trailing: IconButton(
                              onPressed: () async {
                                try {
                                  if (widget.isUpgrade) {
                                    updaterNotifier.upgradeRclone(
                                        asset['browser_download_url']);
                                  } else {
                                    updaterNotifier.installRclone(
                                        asset['browser_download_url']);
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
                              },
                              icon: const Icon(Icons.file_download_outlined),
                            ),
                          );
                        }).toList(),
                      )),
          ],
        ));
  }
}
