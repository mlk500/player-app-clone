import 'package:flutter/material.dart';

class HintDialog extends StatelessWidget {
  final String hint;

  const HintDialog({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hint'),
      content: Text(hint),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  static Future<void> show(BuildContext context, String hint) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return HintDialog(hint: hint);
      },
    );
  }
}
