import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/settings_provider.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(settingsProvider).locale;

    return Scaffold(
      appBar: AppBar(
          title: Text(t.languageSettings.language,
              style: const TextStyle(fontWeight: FontWeight.bold))),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            children: [
              ...[null, ...AppLocale.values].map((locale) {
                return ListTile(
                  onTap: () async {
                    await ref.read(settingsProvider.notifier).setLocale(locale);
                    if (locale == null) {
                      LocaleSettings.useDeviceLocale();
                    } else {
                      LocaleSettings.setLocale(locale);
                    }
                  },
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                            locale?.humanName ?? t.languageSettings.system),
                      ),
                      if (locale == activeLocale) ...[
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

extension AppLocaleExt on AppLocale {
  String get humanName {
    return LocaleSettings.instance.translationMap[this]!.locale;
  }
}
