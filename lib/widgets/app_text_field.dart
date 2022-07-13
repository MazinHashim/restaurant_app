import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String lblText;
  final IconData icon;
  final bool isSecure;
  final String? initialValue;
  final int maxLines;
  final TextInputType keyboardType;
  final Function onSaved;
  final Function onValidate;
  final Widget? suffix;
  final TextEditingController? controller;

  const AppTextFormField(
      {Key? key,
      required this.lblText,
      required this.icon,
      this.isSecure = false,
      this.maxLines = 0,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      required this.onSaved,
      required this.onValidate,
      this.suffix,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        // initialValue: null,
        initialValue: isSecure ? null : initialValue,
        obscureText: isSecure,
        controller: controller,
        maxLines: maxLines != 0 ? 10 : 1,
        keyboardType: keyboardType,
        onSaved: (value) => onSaved(value),
        validator: (value) => onValidate(value),
        decoration: InputDecoration(
            fillColor: const Color(0xffd9d9d9),
            filled: true,
            labelText: lblText,
            alignLabelWithHint: true,
            prefixIcon: Icon(icon),
            suffix: suffix,
            border: const OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
