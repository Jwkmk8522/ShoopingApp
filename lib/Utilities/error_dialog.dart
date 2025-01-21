import 'package:flutter/material.dart';
import 'package:shooping_app/Utilities/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
      context: context,
      title: const Text('An Error Accoured'),
      content: Text(text),
      optionsBuilder: () => {
            'ok': null,
          });
}
