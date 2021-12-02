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
  const ReportsScreen({required this.auth, required this.onSignOut});

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
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: BuildDrawer(
        leading: "Reports",
        auth: widget.auth,
        onSignOut: widget.onSignOut,
        name: "Gabe Newell",
        email: "gaben23@gmail.com",
        profileImage:
            "https://static.wikia.nocookie.net/half-life/images/6/62/Gaben.jpg/revision/latest?cb=20200126040848&path-prefix=en",
        backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Reports"),
      ),
      body: Container(
        //color: Colors.red,
        height: screenSize.height,
        width: screenSize.width, child: screens[currentIndext],
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
    );
  }
}
