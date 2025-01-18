import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child; // The main widget (e.g., an icon)
  final String value; // The badge text (e.g., count)
  final Color? color; // Badge background color

  const Badgee({
    required this.child,
    required this.value,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child, // The main widget (icon in this case)
        // if (value != '0')
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color:
                  color != null ? color : Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
