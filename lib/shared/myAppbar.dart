import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMainAppBar extends StatelessWidget {
  final VoidCallback onPressendDrawer;
  final int notifCount;

  const MyMainAppBar({
    required this.onPressendDrawer,
    required this.notifCount,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: 45,
      width: screenSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.bars,
              size: 20,
            ),
            onPressed: onPressendDrawer,
          ),
          IconButton(
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
                    ),
                  )
                : Icon(
                    FontAwesomeIcons.bell,
                    size: 22,
                  ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
