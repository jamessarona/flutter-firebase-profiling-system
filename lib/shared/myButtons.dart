import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class MyRaisedButton extends StatelessWidget {
  final double elavation;
  final Color color;
  final double radius;
  final VoidCallback onPressed;
  final bool isLoading;
  final Text text;
  const MyRaisedButton(
      {required this.elavation,
      required this.color,
      required this.radius,
      required this.onPressed,
      required this.isLoading,
      required this.text});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      elevation: elavation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      onPressed: onPressed,
      child: !isLoading ? text : MySpinKitCircle(),
    );
  }
}
