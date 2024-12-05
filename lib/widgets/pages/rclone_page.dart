import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/settings_provider.dart';

import 'package:alisthelper/widgets/button_card.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RclonePage extends ConsumerWidget {
  final SizingInformation sizingInformation;

  const RclonePage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    const ls = [];
    return Scaffold(
        appBar: (sizingInformation.isDesktop
            ? null
            : AppBar(
                title: const Text('Rclone',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        body: settings.rcloneDirectory == ''
            ? Center(
                child: Text(t.settings.rcloneSettings.rcloneDirNotSet,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18)),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Q&A'),
                                content: Text(t.rcloneOperation.help),
                              ),
                            );
                          },
                        )),
                    const RcloneMultiButtonCard(),
                    ListTile(
                      title: Text('t.rclone.manageVirtualDisks',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      trailing: AddNewRcloneDisk(),
                    ),
                    Expanded(
                      child: ls.isEmpty
                          ? Center(
                              child: Text('No virtual disks found',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                            )
                          : ListView.builder(
                              itemCount: ls.length,
                              itemBuilder: (context, index) {
                                return ls[index];
                              },
                            ),
                    )
                  ],
                ),
              )));
  }
}

class AddNewRcloneDisk extends StatelessWidget {
  const AddNewRcloneDisk({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 800,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('t.rclone.create',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      Expanded(
                          child: ListView(children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            helperText: 'The name of the disk',
                            hintText: 'OneDrive',
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Path',
                            helperText:
                                'The path after https://localhost:port/dav/',
                            hintText: 'onedrive',
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'MountPoint',
                            helperText: 'The mount point of the disk',
                            hintText: 'T',
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'ExtraFlags',
                            hintText:
                                '--vfs-cache-mode writes --vfs-cache-max-size 100M',
                            helperText: 'Extra flags to pass to rclone',
                          ),
                        ),
                      ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Save'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      label: Text('Add'),
      icon: const Icon(Icons.playlist_add),
    );
  }
}

class RcloneVirtualDisk extends StatelessWidget {
  const RcloneVirtualDisk({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListTile(
            leading: Icon(Icons.settings_system_daydream),
            title: Text('t.rclone.remote.diskName',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            subtitle: Text(
              't.rclone.remote.diskInfo',
            ),
            trailing: Wrap(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
              ],
            )));
  }
}
