import 'dart:async';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/widgets/logs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AlistMultiButtonCard extends ConsumerWidget {
  const AlistMultiButtonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alistState = ref.watch(alistProvider);
    final alistNotifier = ref.read(alistProvider.notifier);

    Future<void> openGUI() async {
      final Uri url = Uri.parse(alistState.url);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch the $url');
      }
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Container(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10.0,
              spacing: 10.0,
              children: [
                ElevatedButton(
                    onPressed: alistState.isRunning
                        ? null
                        : () => alistNotifier.startAlist(),
                    child: Text(t.alistOperation.startAlist)),
                ElevatedButton(
                    onPressed: alistState.isRunning
                        ? () => alistNotifier.endAlist()
                        : null,
                    child: Text(t.alistOperation.endAlist)),
                ElevatedButton(
                    onPressed: alistState.isRunning ? openGUI : null,
                    child: Text(t.alistOperation.openGUI)),
                ElevatedButton(
                    onPressed: () => alistNotifier.genRandomPwd(),
                    child: Text(t.alistOperation.genRandomPwd)),
                ElevatedButton(
                    onPressed: () =>
                        alistNotifier.getAlistCurrentVersion(addToOutput: true),
                    child: Text(t.alistOperation.getVersion)),
              ],
            ),
          ),
          Container(height: 10),
        ],
      ),
    );
  }
}

class RcloneMultiButtonCard extends ConsumerWidget {
  const RcloneMultiButtonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rcloneState = ref.watch(rcloneProvider);
    final rcloneNotifier = ref.read(rcloneProvider.notifier);

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Container(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10.0,
              spacing: 10.0,
              children: [
                ElevatedButton(
                    onPressed: rcloneState.isRunning
                        ? null
                        : () => rcloneNotifier.startRclone(),
                    child: Text(t.rcloneOperation.startRclone)),
                ElevatedButton(
                    onPressed: rcloneState.isRunning
                        ? () => rcloneNotifier.endRclone()
                        : null,
                    child: Text(t.rcloneOperation.endRclone)),
                ElevatedButton(
                    onPressed: () => rcloneNotifier.getRcloneInfo(),
                    child: Text(t.rcloneOperation.getRcloneInfo)),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Logs"),
                            content: SizedBox(
                              height: 400,
                              width: 800,
                              child: Card(
                                child: LogsViewer(
                                    output: ref.watch(rcloneProvider).output),
                              ),
                            ));
                      },
                    );
                  },
                  child: Text("t.rcloneOperation.logs"),
                ),
              ],
            ),
          ),
          Container(height: 10),
        ],
      ),
    );
  }
}
