import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/alist_state.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChoosePackage extends ConsumerStatefulWidget {
  final bool isUpgrade;
  const ChoosePackage({super.key, required this.isUpgrade});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChoosePackageState();
}

class _ChoosePackageState extends ConsumerState<ChoosePackage> {
  @override
  Widget build(BuildContext context) {
    final alistState = ref.watch(alistProvider);
    final AlistNotifier alistNotifier = ref.read(alistProvider.notifier);
    final SettingsState settingsState = ref.watch(settingsProvider);
    try {
      if (alistState.newReleaseAssets.isEmpty) {
        alistNotifier.fetchLatestVersion();
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
                        'Will be upgrade from: ${settingsState.workingDirectory}')
                    : Text(
                        'Will be installed to: ${settingsState.workingDirectory}'),
              ),
            ),
            Center(
              child: alistState.upgradeStatus == UpgradeStatus.installing
                  ? const LinearProgressIndicator()
                  : alistState.upgradeStatus == UpgradeStatus.complete
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
            Column(
              children: (alistState.newReleaseAssets.isEmpty)
                  ? [Text(t.upgrade.networkError)]
                  : alistState.newReleaseAssets.map((asset) {
                      return ListTile(
                        title: Text(asset['name']),
                        leading: const Icon(Icons.grid_view_outlined),
                        subtitle: Text(
                            '${(asset['size'] / 1000000).toStringAsFixed(2)} MB'),
                        trailing: IconButton(
                          onPressed: () async {
                            try {
                              if (widget.isUpgrade) {
                                alistNotifier.upgradeAlist(
                                    asset['browser_download_url']);
                              } else {
                                alistNotifier.installAlist(
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
            ),
          ],
        ));
  }
}
