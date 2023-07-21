import 'dart:io';

import 'package:alisthelper/provider/app_arguments_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appArguments = ref.watch(appArgumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DebugEntry(name: 'Debug Mode', value: kDebugMode.toString()),
          DebugEntry(
              name: 'App Arguments',
              value: appArguments.isEmpty ? null : appArguments.join(' ')),
          DebugEntry(name: 'Dart SDK Version', value: Platform.version),
          DebugEntry(name: 'Platform', value: Platform.operatingSystem),
          DebugEntry(
              name: 'Platform Version', value: Platform.operatingSystemVersion),
          
        ],
      ),
    );
  }
}

class DebugEntry extends StatelessWidget {
  static const headerStyle = TextStyle(fontWeight: FontWeight.bold);

  final String name;
  final String? value;

  const DebugEntry({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(name, style: headerStyle),
        CopyableText(
          name: name,
          value: value,
        ),
      ],
    );
  }
}

class CopyableText extends StatelessWidget {
  final TextSpan? prefix;
  final String name;
  final String? value;

  const CopyableText(
      {super.key, this.prefix, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: value == null
          ? null
          : () async {
              if (context.mounted) {
                Clipboard.setData(ClipboardData(text: value.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied $name to clipboard!'),
                  ),
                );
              }
            },
      child: Text.rich(
        TextSpan(
          children: [
            if (prefix != null) prefix!,
            TextSpan(text: value ?? '-'),
          ],
        ),
      ),
    );
  }
}
