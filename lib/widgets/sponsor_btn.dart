import 'package:alisthelper/i18n/strings.g.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorBtn extends StatelessWidget {
  const SponsorBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(t.home.options,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      trailing: TextButton.icon(
        onPressed: () {
          final locale = Localizations.localeOf(context).toString();
          final url = locale == 'zh_Hans_CN'
              ? 'https://github.com/Xmarmalade/alisthelper/wiki/sponsor_cn'
              : 'https://github.com/Xmarmalade/alisthelper/wiki/sponsor';
          launchUrl(Uri.parse(url));
        },
        label: Text(t.button.sponsor),
        icon: Icon(Icons.star_border_outlined),
      ),
    );
  }
}
