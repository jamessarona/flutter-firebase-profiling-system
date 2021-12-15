import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAppBarLeading extends StatelessWidget {
  final VoidCallback onPressendDrawer;
  const MyAppBarLeading({required this.onPressendDrawer});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.bars,
        size: 20,
        color: Colors.black,
      ),
      onPressed: onPressendDrawer,
    );
  }
}

class MyAppBarAction extends StatelessWidget {
  final int notifCount;
  final Color color;
  final VoidCallback onPressed;
  const MyAppBarAction(
      {required this.notifCount, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: notifCount > 0
          ? Badge(
              badgeContent: Text(
                notifCount > 99 ? "99" : notifCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: notifCount > 10 ? 10 : 13,
                ),
              ),
              child: Icon(
                FontAwesomeIcons.bell,
                size: 22,
                color: color,
              ),
            )
          : Icon(
              FontAwesomeIcons.bell,
              size: 22,
              color: color,
            ),
      onPressed: onPressed,
    );
  }
}
