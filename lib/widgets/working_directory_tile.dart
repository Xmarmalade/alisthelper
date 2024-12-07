import 'dart:io';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkingDirectoryTile extends ConsumerWidget {
  const WorkingDirectoryTile({super.key});

  Future<void> openDirectory(String dir) async {
    final Uri url = Uri.parse('file:$dir');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch the $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final alistNotifier = ref.read(alistProvider.notifier);
    final TextEditingController workingDirectoryController =
        TextEditingController(text: settings.workingDirectory);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.workingDirectory.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(settings.workingDirectory),
      trailing: ElevatedButton(
        onPressed: () async {
          final String? path = await showDialog<String>(
            context: context, // use the new context variable here
            builder: (BuildContext context) {
              // use the new context variable here
              return AlertDialog(
                title: Text(t.settings.alistSettings.workingDirectory.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(t.settings.alistSettings.workingDirectory.hint),
                    TextField(
                      controller: workingDirectoryController,
                      decoration: InputDecoration(
                        labelText: t.settings.alistSettings.workingDirectory
                            .description,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final String? selectedDirectory =
                            await getDirectoryPath();
                        if (selectedDirectory != null) {
                          workingDirectoryController.text = selectedDirectory;
                        }
                      },
                      child: Text(
                          t.settings.alistSettings.workingDirectory.chooseFrom),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.button.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final directory =
                          Directory(workingDirectoryController.text);
                      final String programName =
                          Platform.isWindows ? "alist.exe" : "alist";
                      try {
                        final List<FileSystemEntity> files =
                            await directory.list().toList();
                        if (files.any(
                            (element) => element.path.endsWith(programName))) {
                          if (context.mounted) {
                            Navigator.of(context)
                                .pop(workingDirectoryController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t
                                    .settings.alistSettings.workingDirectory
                                    .found(exec: programName)),
                              ),
                            );
                          }
                        } else {
                          workingDirectoryController.text =
                              settings.workingDirectory;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t
                                    .settings.alistSettings.workingDirectory
                                    .notFound(exec: programName)),
                              ),
                            );
                          }
                        }
                      } on Exception catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(t.button.ok),
                  ),
                ],
              );
            },
          );
          if (path != null) {
            await alistNotifier.setWorkDir(path);
          }
        },
        child: Text(t.button.select),
      ),
      onLongPress: () {
        openDirectory(settings.workingDirectory);
      },
    );
  }
}

class RcloneDirectoryTile extends ConsumerWidget {
  const RcloneDirectoryTile({super.key});

  Future<void> openDirectory(String dir) async {
    final Uri url = Uri.parse('file:$dir');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch the $url');
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final SettingsState settings = ref.watch(settingsProvider);
    final SettingsNotifier settingsNotifier =
        ref.read(settingsProvider.notifier);
    final TextEditingController rcloneDirectoryController =
        TextEditingController(text: settings.rcloneDirectory);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.workingDirectory.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(settings.rcloneDirectory),
      trailing: ElevatedButton(
        onPressed: () async {
          final String? path = await showDialog<String>(
            context: context, // use the new context variable here
            builder: (BuildContext context) {
              // use the new context variable here
              return AlertDialog(
                title: Text(t.settings.alistSettings.workingDirectory.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(t.settings.alistSettings.workingDirectory.hint),
                    TextField(
                      controller: rcloneDirectoryController,
                      decoration: InputDecoration(
                        labelText: t.settings.alistSettings.workingDirectory
                            .description,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final String? selectedDirectory =
                            await getDirectoryPath();
                        if (selectedDirectory != null) {
                          rcloneDirectoryController.text = selectedDirectory;
                        }
                      },
                      child: Text(
                          t.settings.alistSettings.workingDirectory.chooseFrom),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.button.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final directory =
                          Directory(rcloneDirectoryController.text);
                      final String programName =
                          Platform.isWindows ? "rclone.exe" : "rclone";
                      try {
                        final List<FileSystemEntity> files =
                            await directory.list().toList();
                        if (files.any(
                            (element) => element.path.endsWith(programName))) {
                          if (context.mounted) {
                            Navigator.of(context)
                                .pop(rcloneDirectoryController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t
                                    .settings.alistSettings.workingDirectory
                                    .found(exec: programName)),
                              ),
                            );
                          }
                        } else {
                          rcloneDirectoryController.text =
                              settings.workingDirectory;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t
                                    .settings.alistSettings.workingDirectory
                                    .notFound(exec: programName)),
                              ),
                            );
                          }
                        }
                      } on Exception catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(t.button.ok),
                  ),
                ],
              );
            },
          );
          if (path != null) {
            await settingsNotifier.setRcloneDirectory(path);
          }
        },
        child: Text(t.button.select),
      ),
      onLongPress: () {
        openDirectory(settings.rcloneDirectory);
      },
    );
  }
}
