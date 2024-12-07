import 'package:alisthelper/utils/textutils.dart';

import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RcloneMountAccountTile extends ConsumerWidget {
  const RcloneMountAccountTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState settings = ref.watch(settingsProvider);
    final SettingsNotifier settingsNotifier =
        ref.read(settingsProvider.notifier);
    String user = 'dav';
    String pwd = 'dav';
    if (settings.webdavAccount.isEmpty) {
      settingsNotifier.setWebdavAccount(TextUtils.accountEncoder([user, pwd]));
    } else {
      [user, pwd] = TextUtils.accountParser(settings.webdavAccount);
    }
    return ListTile(
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        title: Text(t.settings.rcloneSettings.account.title,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: ElevatedButton(
          onPressed: () async {
            // show a dialog to edit the rclone account
            final result = await showDialog<List<String>>(
                context: context,
                builder: (context) {
                  final userController = TextEditingController(text: user);
                  final pwdController = TextEditingController(text: pwd);
                  return AlertDialog(
                    title: Text(t.settings.rcloneSettings.account.description),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop([userController.text, pwdController.text]);
                        },
                        child: Text(t.button.save),
                      ),
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: userController,
                          decoration: InputDecoration(
                              labelText:
                                  t.settings.rcloneSettings.account.name),
                        ),
                        TextField(
                          controller: pwdController,
                          decoration: InputDecoration(
                              labelText:
                                  t.settings.rcloneSettings.account.pass),
                        ),
                      ],
                    ),
                  );
                });
            if (result != null && result.length == 2) {
              final [user, pwd] = result;
              settingsNotifier
                  .setWebdavAccount(TextUtils.accountEncoder([user, pwd]));
            }
          },
          child: Text(t.button.edit),
        ));
  }
}
