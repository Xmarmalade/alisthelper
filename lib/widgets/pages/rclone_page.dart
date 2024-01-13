import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';

import 'package:alisthelper/widgets/button_card.dart';
import 'package:alisthelper/widgets/logs_viewer.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RclonePage extends ConsumerWidget {
  final SizingInformation sizingInformation;

  const RclonePage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final settings = ref.watch(settingsProvider);
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
                      title: Text(t.home.logs,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    Expanded(
                      child: Card(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: LogsViewer(
                              output: ref.watch(rcloneProvider).output)),
                    ),
                  ],
                ),
              )));
  }
}
