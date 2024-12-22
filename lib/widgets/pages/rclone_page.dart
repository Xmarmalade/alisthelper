import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/virtual_disk_state.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/widgets/add_new_vdisk.dart';

import 'package:alisthelper/widgets/button_card.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class RclonePage extends ConsumerWidget {
  final SizingInformation sizingInformation;

  const RclonePage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final rclone = ref.watch(rcloneProvider);
    final String message;

    if (settings.rcloneDirectory == '' && settings.webdavAccount == '') {
      message =
          '${t.settings.rcloneSettings.rcloneDirNotSet}\n${t.settings.rcloneSettings.rcloneWebdavNotSet}';
    } else if (settings.rcloneDirectory == '') {
      message = t.settings.rcloneSettings.rcloneDirNotSet;
    } else if (settings.webdavAccount == '') {
      message = t.settings.rcloneSettings.rcloneWebdavNotSet;
    } else {
      message = 'Error\nPlease check your settings';
    }

    return Scaffold(
        appBar: (sizingInformation.isDesktop
            ? null
            : AppBar(
                title: const Text('Rclone',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        body: (settings.rcloneDirectory == '' || settings.webdavAccount == '')
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                ),
              )
            : Center(
                child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(t.home.options,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      trailing: HelpButton(),
                    ),
                    const RcloneMultiButtonCard(),
                    ListTile(
                        title: Text(t.home.manage,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        trailing: AddNewRcloneDisk()),
                    Expanded(
                      child: (rclone.vdList.isEmpty)
                          ? NoVdisks()
                          : Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: ListView.builder(
                                itemCount: rclone.vdList.length,
                                itemBuilder: (context, index) {
                                  return RcloneVirtualDisk(
                                      vd: rclone.vdList[index]);
                                },
                              ),
                            ),
                    )
                  ],
                ),
              )));
  }
}

class NoVdisks extends StatelessWidget {
  const NoVdisks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(t.rcloneOperation.noVdisks,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
    );
  }
}

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => launchUrl(
            Uri.parse('https://github.com/Xmarmalade/alisthelper/wiki')),
        icon: Icon(Icons.info_outline_rounded),
        label: Text(t.button.docs));
  }
}

class RcloneVirtualDisk extends ConsumerWidget {
  const RcloneVirtualDisk({
    super.key,
    required this.vd,
  });

  final VirtualDiskState vd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rcloneNotifier = ref.watch(rcloneProvider.notifier);

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: Icon(Icons.settings_system_daydream),
        title: Text(vd.name.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        subtitle: Text(
          '${vd.mountPoint}: /${vd.path} ${vd.extraFlags}',
        ),
        trailing: Wrap(
          children: [
            EditRcloneDisk(disk: vd),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                //rcloneNotifier.deleteSpecific(vd);
                // showDialog to confirm deletion
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(t.rcloneOperation.deleteVdisk(name: vd.name)),
                    actions: [
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(t.button.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          rcloneNotifier.deleteSpecific(vd);
                          Navigator.of(context).pop();
                        },
                        child: Text(t.button.yes),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: vd.isMounted
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.play_arrow),
              onPressed: !ref.watch(rcloneProvider).isRunning
                  ? null
                  : () {
                      rcloneNotifier.toggleMount(vd);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
