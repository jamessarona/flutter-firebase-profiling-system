import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextInputType? inputType;
  final bool isObscureText;
  final FormFieldValidator<String>? validation;
  final FormFieldValidator<String>? onChanged;
  final GestureDetector? prefixIcon;
  final String? labelText;
  final String? hintText;
  MyTextFormField({
    this.inputType,
    required this.isObscureText,
    this.validation,
    this.onChanged,
    this.prefixIcon,
    this.labelText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: isObscureText,
      validator: validation,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
