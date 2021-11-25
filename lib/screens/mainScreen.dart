import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';

class MainScreen extends StatefulWidget {
  final String? leading;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  MainScreen({this.leading, required this.auth, required this.onSignOut});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Size screenSize;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: BuildDrawer(
          leading: "Statistics",
          auth: widget.auth,
          onSignOut: widget.onSignOut,
          name: "Gabe Newell",
          email: "gaben23@gmail.com",
          profileImage:
              "https://static.wikia.nocookie.net/half-life/images/6/62/Gaben.jpg/revision/latest?cb=20200126040848&path-prefix=en",
          backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
        ),
        body: Container(
            height: screenSize.height,
            width: screenSize.width,
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  'data',
                ),
              ],
            )));
  }
}
