import 'package:flutter/material.dart';
import './generic_dialog.dart';

Future<bool> showdeletedialog(
  BuildContext context,
  String title,
  String textt,
) {
  return showGenericDialog<bool>(
    context: context,
    title: Text(
      textt,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    content: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ),
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
