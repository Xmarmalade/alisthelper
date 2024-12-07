import 'dart:async';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/widgets/pages/logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AlistMultiButtonCard extends ConsumerWidget {
  const AlistMultiButtonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alistState = ref.watch(alistProvider);
    final alistNotifier = ref.watch(alistProvider.notifier);

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
                FilledButton.tonal(
                    onPressed: alistState.isRunning
                        ? null
                        : () => alistNotifier.startAlist(),
                    child: Text(t.alistOperation.startAlist)),
                FilledButton.tonal(
                    onPressed: alistState.isRunning
                        ? () => alistNotifier.endAlist()
                        : null,
                    child: Text(t.alistOperation.endAlist)),
                FilledButton.tonal(
                    onPressed: alistState.isRunning ? openGUI : null,
                    child: Text(t.alistOperation.openGUI)),
                FilledButton.tonal(
                    onPressed: () => alistNotifier.genRandomPwd(),
                    child: Text(t.alistOperation.genRandomPwd)),
                FilledButton.tonal(
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
    final rcloneNotifier = ref.watch(rcloneProvider.notifier);

    // Assuming rcloneState.output is a list of strings
    final unreadCount = rcloneState.output.length;

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
                FilledButton.tonal(
                    onPressed: rcloneState.isRunning
                        ? null
                        : () => rcloneNotifier.startRclone(),
                    child: Text(t.rcloneOperation.startRclone)),
                FilledButton.tonal(
                    onPressed: rcloneState.isRunning
                        ? () => rcloneNotifier.endRclone()
                        : null,
                    child: Text(t.rcloneOperation.endRclone)),
                FilledButton.tonal(
                    onPressed: () => rcloneNotifier.getRcloneInfo(),
                    child: Text(t.rcloneOperation.getRcloneInfo)),
                Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text(unreadCount.toString()),
                  child: FilledButton.tonal(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog.fullscreen(
                          child: RcloneLogsPage(),
                        ),
                      );
                    },
                    child: Text(t.rcloneOperation.viewLogs),
                  ),
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
