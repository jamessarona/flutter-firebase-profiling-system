import 'package:flutter/material.dart';
import 'package:tanood/shared/constants.dart';

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
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: customColor[110],
          boxShadow: [
            BoxShadow(
              color: selectedLabel == title
                  ? customColor[140]!.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          title,
          style: tertiaryText.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: selectedLabel == title ? customColor[140] : Colors.grey,
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

class MyReportDetails extends StatelessWidget {
  final EdgeInsets margin;
  final double width;
  final Text label;
  const MyReportDetails({
    required this.margin,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: label,
    );
  }
}
