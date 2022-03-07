import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/locationsScreen.dart';
import 'package:tanood/screens/mainScreen.dart';
import 'package:tanood/screens/registrationScreen.dart';
import 'package:tanood/screens/tanodsStatusScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myCards.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSignOut;
  final BaseAuth auth;
  final String userUID;
  const SettingsScreen({
    required this.auth,
    required this.onSignOut,
    required this.userUID,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => MainScreen(
                    leading: 'Home',
                    auth: widget.auth,
                    onSignOut: widget.onSignOut,
                  ),
                ),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            'Settings',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 4,
                        bottom: 5,
                      ),
                      child: Text(
                        'Users Settings',
                        style: tertiaryText.copyWith(
                            fontSize: 16,
                            letterSpacing: 0,
                            color: Colors.grey[800]),
                      ),
                    ),
                    MyInformationCard(
                      icon: 'add-user.png',
                      //  Icon(
                      //   FontAwesomeIcons.folderOpen,
                      //   color: customColor[130],
                      // ),
                      text: "Registration",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RegistrationScreen(
                              onSignOut: widget.onSignOut,
                              auth: widget.auth,
                            ),
                          ),
                        );
                      },
                    ),
                    MyInformationCard(
                      icon: 'group.png',
                      //  Icon(
                      //   FontAwesomeIcons.folderOpen,
                      //   color: customColor[130],
                      // ),
                      text: "Tanods",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => TanodsStatusScreen(
                              userUID: widget.userUID,
                              onSignOut: widget.onSignOut,
                              auth: widget.auth,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        left: 4,
                        bottom: 5,
                      ),
                      child: Text(
                        'Location Settings',
                        style: tertiaryText.copyWith(
                            fontSize: 16,
                            letterSpacing: 0,
                            color: Colors.grey[800]),
                      ),
                    ),
                    MyInformationCard(
                      icon: 'map-location.png',
                      //  Icon(
                      //   FontAwesomeIcons.folderOpen,
                      //   color: customColor[130],
                      // ),
                      text: "Locations",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => LocationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
