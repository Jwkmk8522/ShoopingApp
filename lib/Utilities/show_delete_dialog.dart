import 'package:flutter/material.dart';
import './generic_dialog.dart';

Future<bool> showdeletedialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: Text(
      "Delete",
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    content: Text(
      'Are you sure you want to Delete this Product From Cart?',
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
