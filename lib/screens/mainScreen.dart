import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';

class MainScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  MainScreen({required this.auth, required this.onSignOut});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Size screenSize;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Material(
            //https://static.wikia.nocookie.net/half-life/images/6/62/Gaben.jpg/revision/latest?cb=20200126040848&path-prefix=en
            color: customColor,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                BuildDrawerMenuHeader(
                  image:
                      "https://static.wikia.nocookie.net/half-life/images/6/62/Gaben.jpg/revision/latest?cb=20200126040848&path-prefix=en",
                  name: "Gabe Newell",
                  contact: "093921321123",
                  email: "gaben23@gmail.com",
                ),
                const SizedBox(height: 48),
                BuildDrawerMenuItem(
                  text: "Statistics",
                  icon: FontAwesomeIcons.chartArea,
                  // onTap: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (ctx) => StatisticsScreen(),
                  //     ),
                  //   );
                  // },
                ),
                BuildDrawerMenuItem(
                  text: "Reports",
                  icon: FontAwesomeIcons.userClock,
                  // onTap: () {},
                ),
                BuildDrawerMenuItem(
                  text: "Dropped Report",
                  icon: Icons.verified_user,
                  //  onTap: () {},
                ),
                BuildDrawerMenuItem(
                  text: "Apprehended Report",
                  icon: Icons.verified_user,
                  // onTap: () {},
                ),
                BuildDrawerMenuItem(
                  text: "People Information",
                  icon: FontAwesomeIcons.users,
                  //  onTap: () {},
                ),
                const SizedBox(height: 24),
                Divider(
                  color: Colors.white70,
                ),
                const SizedBox(height: 24),
                BuildDrawerMenuItem(
                  text: "Settings",
                  icon: FontAwesomeIcons.cog,
                  // onTap: () {},
                ),
                BuildDrawerMenuItem(
                  text: "Logout",
                  icon: FontAwesomeIcons.solidShareSquare,
                  //  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 10,
              top: 20,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
            ),
            Center(
                child: new Column(
              children: <Widget>[
                Container(
                  //color: Colors.red,
                  height: screenSize.height,
                  width: screenSize.width,
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
