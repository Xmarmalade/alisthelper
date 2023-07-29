import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';

import 'package:flutter/material.dart';

class AlistArgsTile extends StatelessWidget {
  const AlistArgsTile({
    Key? key,
    required this.settings,
    required this.settingsNotifier,
  }) : super(key: key);

  final SettingsState settings;
  final SettingsNotifier settingsNotifier;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.argumentsList.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(settings.alistArgs.join(', ')),
      trailing: ElevatedButton(
        onPressed: () async {
          final args = await showDialog<List<String>>(
            context: context,
            builder: (context) => _AlistArgsDialog(
              initialArgs: settings.alistArgs,
            ),
          );
          if (args != null) {
            settingsNotifier.setAlistArgs(args);
          }
        },
        child: Text(t.button.edit),
      ),
    );
  }
}

class _AlistArgsDialog extends StatefulWidget {
  const _AlistArgsDialog({Key? key, required this.initialArgs})
      : super(key: key);

  final List<String> initialArgs;

  @override
  __AlistArgsDialogState createState() => __AlistArgsDialogState();
}

class __AlistArgsDialogState extends State<_AlistArgsDialog> {
  late List<String> args;

  @override
  void initState() {
    super.initState();
    args = List.from(widget.initialArgs);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(t.settings.alistSettings.argumentsList.title),
        subtitle: Text(t.settings.alistSettings.argumentsList.description),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < args.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: args[i],
                      onChanged: (value) => args[i] = value,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        args.removeAt(i);
                      });
                    },
                    icon: const Icon(Icons.delete_forever_rounded),
                  ),
                ],
              ),
            Container(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  args.add('');
                });
              },
              child: Text(t.settings.alistSettings.argumentsList.addArgument),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.button.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(args),
          child: Text(t.button.save),
        ),
      ],
    );
  }
}

class RcloneArgsTile extends StatelessWidget {
  const RcloneArgsTile({
    Key? key,
    required this.settings,
    required this.settingsNotifier,
  }) : super(key: key);

  final SettingsState settings;
  final SettingsNotifier settingsNotifier;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.argumentsList.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(settings.rcloneArgs.join(', ')),
      trailing: ElevatedButton(
        onPressed: () async {
          final args = await showDialog<List<String>>(
            context: context,
            builder: (context) => _RcloneArgsDialog(
              initialArgs: settings.rcloneArgs,
            ),
          );
          if (args != null) {
            settingsNotifier.setRcloneArgs(args);
          }
        },
        child: Text(t.button.edit),
      ),
    );
  }
}

class _RcloneArgsDialog extends StatefulWidget {
  const _RcloneArgsDialog({Key? key, required this.initialArgs})
      : super(key: key);

  final List<String> initialArgs;

  @override
  __RcloneArgsDialogState createState() => __RcloneArgsDialogState();
}

class __RcloneArgsDialogState extends State<_RcloneArgsDialog> {
  late List<String> args;

  @override
  void initState() {
    super.initState();
    args = List.from(widget.initialArgs);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(t.settings.alistSettings.argumentsList.title),
        subtitle:
            Text(t.settings.alistSettings.argumentsList.descriptionForRclone),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < args.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: args[i],
                      onChanged: (value) => args[i] = value,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        args.removeAt(i);
                        print(args);
                      });
                    },
                    icon: const Icon(Icons.delete_forever_rounded),
                  ),
                ],
              ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      args = [];
                    });
                  },
                  child: Text(t.settings.alistSettings.argumentsList.removeAll),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      args.add('');
                    });
                  },
                  child:
                      Text(t.settings.alistSettings.argumentsList.addArgument),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.button.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (args.length == 1 && args[0].contains(' ')) {
              args = args[0].split(' ');
              if (args[0].contains('rclone')) {
                args.removeAt(0);
              }
              for (var i = 0; i < args.length; i++) {
                if (args[i].contains('"')) {
                  args[i] = args[i].replaceAll('"', '');
                }
              }
            }
            Navigator.of(context).pop(args);
          },
          child: Text(t.button.save),
        ),
      ],
    );
  }
}
