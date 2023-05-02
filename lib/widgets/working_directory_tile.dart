
import 'dart:io';

import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
class WorkingDirectoryTile extends StatelessWidget {
  const WorkingDirectoryTile({
    Key? key,
    required this.settings,
    required this.settingsNotifier,
  }) : super(key: key);

  final SettingsState settings;
  final SettingsNotifier settingsNotifier;

  @override
  @override
  Widget build(BuildContext context) {
    final TextEditingController workingDirectoryController =
        TextEditingController(text: settings.workingDirectory);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: const Text(
        'Working Directory',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(settings.workingDirectory),
      trailing: ElevatedButton(
        onPressed: () async {
          final String? path = await showDialog<String>(
            context: context, // use the new context variable here
            builder: (BuildContext context) {
              // use the new context variable here
              return AlertDialog(
                title: const Text('Set Working Directory'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('It\'s a Directory, not a File!'),
                    TextField(
                      controller: workingDirectoryController,
                      decoration: const InputDecoration(
                        labelText: 'Directory',
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? selectedDirectory =
                            await FilePicker.platform.getDirectoryPath();
                        if (selectedDirectory != null) {
                          workingDirectoryController.text = selectedDirectory;
                        }
                      },
                      child: const Text('Select from...'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final directory =
                          Directory(workingDirectoryController.text);
                      try {
                        final List<FileSystemEntity> files =
                            await directory.list().toList();
                        if (files.any(
                            (element) => element.path.endsWith('alist.exe'))) {
                          if (context.mounted) {
                            Navigator.of(context)
                                .pop(workingDirectoryController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Found alist.exe'),
                              ),
                            );
                          }
                        } else {
                          workingDirectoryController.text =
                              settings.workingDirectory;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No alist found in directory.'),
                              ),
                            );
                          }
                        }
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          if (path != null) {
            await settingsNotifier.setWorkingDirectory(path);
          }
        },
        child: const Text('Select'),
      ),
    );
  }
}

