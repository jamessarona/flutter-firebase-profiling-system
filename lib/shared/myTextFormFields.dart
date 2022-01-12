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

class MyDocumentationTextFormField extends StatelessWidget {
  final TextInputType inputType;
  final bool isObscureText;
  final FormFieldValidator<String> validation;
  final FormFieldValidator<String> onChanged;
  final GestureDetector? prefixIcon;
  final String labelText;
  final String hintText;
  final bool isReadOnly;
  final String initialValue;
  MyDocumentationTextFormField({
    required this.inputType,
    required this.isObscureText,
    required this.validation,
    required this.onChanged,
    required this.prefixIcon,
    required this.labelText,
    required this.hintText,
    required this.isReadOnly,
    required this.initialValue,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: isObscureText,
      validator: validation,
      onChanged: onChanged,
      readOnly: isReadOnly,
      initialValue: initialValue,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white70,
      ),
    );
  }
}
