import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProxyTile extends ConsumerWidget {
  const ProxyTile({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final alistNotifier = ref.read(alistProvider.notifier);
    final TextEditingController proxyController =
        TextEditingController(text: settings.proxy);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(
        t.settings.alistSettings.proxy.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text((settings.proxy.toString() != '')
          ? settings.proxy.toString()
          : t.settings.alistSettings.proxy.hint),
      trailing: FilledButton.tonal(
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
                    TextField(
                      controller: proxyController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: t.settings.alistSettings.proxy.title,
                          hintText: "http://yourproxy:port",
                          helperText: t.settings.alistSettings.proxy.hint),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.button.cancel),
                  ),
                  FilledButton.tonal(
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
                await alistNotifier.setProxy(proxy);
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
