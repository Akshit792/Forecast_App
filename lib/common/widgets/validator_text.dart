import 'package:flutter/material.dart';

class ValidatorText extends StatelessWidget {
  final String text;
  const ValidatorText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.5, bottom: 12.5),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
    ;
  }
}
