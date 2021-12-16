import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/constants.dart';
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

class MyOutlineButton extends StatelessWidget {
  final double elavation;
  final Color color;
  final double radius;
  final VoidCallback onPressed;
  final bool isLoading;
  final Text text;
  const MyOutlineButton(
      {required this.elavation,
      required this.color,
      required this.radius,
      required this.onPressed,
      required this.isLoading,
      required this.text});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: onPressed,
      child: !isLoading ? text : MySpinKitCircle(),
    );
  }
}

class MyCategoryButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final double padding;
  final double height;
  final double width;
  const MyCategoryButton({
    required this.text,
    required this.color,
    required this.onTap,
    required this.padding,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: padding),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: customColor[110],
          border: Border.all(
            color: color,
          ),
        ),
        child: Text(
          text,
          style: tertiaryText.copyWith(
            fontSize: 15,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MyFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Text title;
  final double radius;
  const MyFloatingButton({
    required this.onPressed,
    required this.title,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: customColor[130],
      onPressed: onPressed,
      child: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
    );
  }
}
