import 'package:flutter/material.dart';

class PrefilTextEditingController {
  static TextEditingController from(String text) {
    return TextEditingController.fromValue(
      TextEditingValue(
        text: ((text != null && text.isNotEmpty) ? text : ""),
        selection: TextSelection.fromPosition(
          TextPosition(
              offset: (text != null && text.isNotEmpty) ? text.length : 0),
        ),
      ),
    );
  }
}
