import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/widgets/logs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alisthelper/i18n/strings.g.dart';

class RcloneLogsPage extends ConsumerWidget {
  const RcloneLogsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(t.rcloneOperation.viewLogs),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: LogsViewer(
                  output: ref.watch(rcloneProvider).output,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
