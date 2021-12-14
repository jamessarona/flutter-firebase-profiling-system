import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MyDateLabel extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String selectedLabel;
  const MyDateLabel({
    required this.title,
    required this.onTap,
    required this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: tertiaryText.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: selectedLabel == title ? customColor[140] : Colors.grey,
        ),
      ),
    );
  }
}
