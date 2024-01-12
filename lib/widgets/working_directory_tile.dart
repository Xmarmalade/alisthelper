import 'dart:io';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkingDirectoryTile extends StatelessWidget {
  const WorkingDirectoryTile({
    super.key,
    required this.settings,
    required this.settingsNotifier,
  });

  final SettingsState settings;
  final SettingsNotifier settingsNotifier;

  Future<void> openDirectory() async {
    final Uri url = Uri.parse('file:${settings.workingDirectory}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch the $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController workingDirectoryController =
        TextEditingController(text: settings.workingDirectory);
    final t = Translations.of(context);
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
                                content: Text(t.settings.alistSettings
                                    .workingDirectory.found),
                              ),
                            );
                          }
                        } else {
                          workingDirectoryController.text =
                              settings.workingDirectory;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t.settings.alistSettings
                                    .workingDirectory.notFound),
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
            await settingsNotifier.setWorkingDirectory(path);
          }
        },
        child: Text(t.button.select),
      ),
      onLongPress: () {
        openDirectory();
      },
    );
  }
}
