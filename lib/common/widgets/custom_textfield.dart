import 'package:a2d_forecast_app/common/widgets/prefill_text_controller.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final void Function()? onTap;
  final String text;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final void Function()? gestureDetector;
  const CustomTextField(
      {required this.hintText,
      required this.textInputType,
      required this.text,
      this.onTap,
      this.onChanged,
      this.suffixIcon,
      this.obscureText = false,
      this.readOnly = false,
      this.gestureDetector,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: gestureDetector,
      child: IgnorePointer(
        ignoring: gestureDetector != null ? true : false,
        child: TextField(
          readOnly: readOnly,
          keyboardType: textInputType,
          onChanged: onChanged,
          obscureText: obscureText,
          controller: PrefilTextEditingController.from(text),
          decoration: InputDecoration(
            suffixIcon: suffixIcon != null ? _buldIcon() : null,
            contentPadding:
                const EdgeInsets.only(left: 24, top: 10, bottom: 10),
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Color.fromRGBO(128, 128, 128, 1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter'),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buldIcon() {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: suffixIcon,
    );
  }
}
