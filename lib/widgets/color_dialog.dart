import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangout/providers/color.dart';
import 'package:ft_hangout/providers/localizations.dart';

class ColorDialog extends StatelessWidget {
  const ColorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return AlertDialog(
      title: Text(context.getText('chooseclr')),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              color.setAppBarColor(Colors.blue);
              Navigator.pop(context);
            },
            child: const CircleAvatar(backgroundColor: Colors.blue),
          ),
          GestureDetector(
            onTap: () {
              color.setAppBarColor(Colors.green);
              Navigator.pop(context);
            },
            child: const CircleAvatar(backgroundColor: Colors.green),
          ),
          GestureDetector(
            onTap: () {
              color.setAppBarColor(Colors.red);
              Navigator.pop(context);
            },
            child: const CircleAvatar(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
