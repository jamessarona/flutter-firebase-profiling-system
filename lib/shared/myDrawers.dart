import 'package:flutter/material.dart';
import 'package:flutter_app_restart/flutter_app_restart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/mainScreen.dart';
import 'package:tanod_apprehension/screens/reportsScreen.dart';
import 'package:tanod_apprehension/screens/statisticsScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class BuildDrawer extends StatelessWidget {
  final String leading;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String name;
  final String email;
  final String profileImage;
  final String backgroundImage;
  final String selectedArea;
  const BuildDrawer(
      {required this.leading,
      required this.auth,
      required this.onSignOut,
      required this.name,
      required this.email,
      required this.profileImage,
      required this.backgroundImage,
      required this.selectedArea});

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Logout"),
      onPressed: () {
        auth.signOut().then((value) async => await FlutterRestart.restartApp());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout Confirmation"),
      content: Text("Would you like to Log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * .65,
      child: Drawer(
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BuildDrawerMenuHeader(
                name: name,
                email: email,
                profileImage: profileImage,
                backgroundImage: backgroundImage,
              ),
              BuildDrawerMenuItem(
                leading: leading,
                text: "Home",
                icon: FontAwesomeIcons.houseUser,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          MainScreen(auth: auth, onSignOut: onSignOut),
                    ),
                  );
                },
              ),
              BuildDrawerMenuItem(
                leading: leading,
                text: "Statistics",
                icon: FontAwesomeIcons.chartBar,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => StatisticsScreen(
                          auth: auth,
                          onSignOut: onSignOut,
                          email: email,
                          name: name,
                          profileImage: profileImage,
                          selectedArea: selectedArea),
                    ),
                  );
                },
              ),
              BuildDrawerMenuItem(
                leading: leading,
                text: "Reports",
                icon: FontAwesomeIcons.userClock,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => ReportsScreen(
                        auth: auth,
                        onSignOut: onSignOut,
                        email: email,
                        name: name,
                        profileImage: profileImage,
                        selectedArea: selectedArea,
                      ),
                    ),
                  );
                },
              ),
              Divider(
                endIndent: screenSize.height / 70,
                indent: screenSize.height / 70,
                color: Colors.black,
              ),
              BuildDrawerMenuItem(
                leading: leading,
                text: "Logout",
                icon: FontAwesomeIcons.shareSquare,
                onTap: () {
                  showAlertDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildDrawerMenuHeader extends StatelessWidget {
  final String name;
  final String email;
  final String profileImage;
  final String backgroundImage;
  const BuildDrawerMenuHeader(
      {required this.name,
      required this.email,
      required this.profileImage,
      required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(name),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        child: ClipOval(
          child: Image.network(
            profileImage,
            height: 90,
            width: 90,
            fit: BoxFit.cover,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: customColor,
        image: DecorationImage(
          image: NetworkImage(
            backgroundImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class BuildDrawerMenuItem extends StatelessWidget {
  final String leading;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const BuildDrawerMenuItem({
    required this.leading,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.black54;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(
        icon,
        color: leading == text ? customColor[130] : color,
      ),
      title: Text(
        text,
        style: TextStyle(color: leading == text ? customColor[130] : color),
      ),
      hoverColor: hoverColor,
      onTap: onTap,
    );
  }
}
