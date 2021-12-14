import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/reportScreens/activeScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';

import 'reportScreens/droppedScreen.dart';
import 'reportScreens/taggedScreen.dart';

class ReportsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;

  final String name;
  final String email;
  final String profileImage;
  final String selectedArea;

  const ReportsScreen({
    required this.auth,
    required this.onSignOut,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.selectedArea,
  });

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

late Size screenSize;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int currentIndext = 0;
final screens = [
  ActiveScreen(),
  DroppedScreen(),
  TaggedScreen(),
];

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: BuildDrawer(
          leading: "Reports",
          auth: widget.auth,
          onSignOut: widget.onSignOut,
          name: widget.name,
          email: widget.email,
          profileImage: widget.profileImage,
          backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
          selectedArea: widget.selectedArea,
        ),
        body: Column(
          children: [
            Container(
              height: screenSize.height * .05,
              width: screenSize.width,
              child: Row(
                children: [
                  DropdownButton<String>(
                    items: <String>['Maa', 'San Rafael', 'Roxas', 'Matina']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )
                ],
              ),
            ),
            Container(
              color: Colors.grey[100],
              height: screenSize.height * .72,
              width: screenSize.width,
              child: screens[currentIndext],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndext,
          onTap: (index) {
            setState(() {
              currentIndext = index;
            });
          },
          type: BottomNavigationBarType.shifting,
          selectedItemColor: customColor,
          selectedLabelStyle: tertiaryText.copyWith(fontSize: 12),
          unselectedItemColor: Colors.black38,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.fire),
              label: "Active",
              tooltip: "New Violator",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.archive),
              label: "Dropped",
              tooltip: "Missed Violator",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userTag),
              label: "Tagged",
              tooltip: "Apprehended Violator",
            ),
          ],
        ),
      ),
    );
  }
}
