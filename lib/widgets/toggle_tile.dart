import 'package:flutter/material.dart';


class CustomToggleTile extends StatelessWidget {
  const CustomToggleTile({
    super.key,
    required this.value,
    required this.onToggled,
    required this.title,
    required this.subtitle,
  });

  final bool value;
  final Function onToggled;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: (value) {
          onToggled(value);
        },
      ),
    );
  }
}

