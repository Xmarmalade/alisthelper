import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/settings_state.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:flutter/material.dart';

class ProxyTile extends StatelessWidget {
  const ProxyTile({
    super.key,
    required this.settings,
    required this.settingsNotifier,
  });

  final SettingsState settings;
  final SettingsNotifier settingsNotifier;

  @override
  @override
  Widget build(BuildContext context) {
    final TextEditingController proxyController =
        TextEditingController(text: settings.proxy);
    final t = Translations.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.proxy.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text((settings.proxy.toString() != '')
          ? settings.proxy.toString()
          : t.settings.alistSettings.proxy.hint),
      trailing: ElevatedButton(
        onPressed: () async {
          final String? proxy = await showDialog<String>(
            context: context, // use the new context variable here
            builder: (BuildContext context) {
              // use the new context variable here
              return AlertDialog(
                title: Text(t.settings.alistSettings.proxy.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(t.settings.alistSettings.proxy.hint),
                    TextField(
                      controller: proxyController,
                      decoration: const InputDecoration(
                          labelText: "http://yourproxy:port"),
                    ),
                    Container(
                      height: 20,
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
                      final proxy = proxyController.text;
                      Navigator.of(context).pop(proxy);
                    },
                    child: Text(t.button.ok),
                  ),
                ],
              );
            },
          );
          if (proxy != null && proxy != settings.proxy) {
            //check url is vaild for http://yourproxy:port
            try {
              if (Uri.parse(proxy).isAbsolute || proxy == '') {
                await settingsNotifier.setProxy(proxy);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.settings.alistSettings.proxy.success),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.settings.alistSettings.proxy.error),
                    ),
                  );
                  proxyController.text = settings.proxy.toString();
                }
              }
            } on Exception catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        t.settings.alistSettings.proxy.error + e.toString()),
                  ),
                );
                proxyController.text = settings.proxy.toString();
              }
            }
          }
        },
        child: Text(t.button.edit),
      ),
    );
  }
}
