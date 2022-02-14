import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/locationsScreen.dart';
import 'package:tanod_apprehension/screens/registrationScreen.dart';
import 'package:tanod_apprehension/screens/tanodsStatusScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  final String userUID;
  const SettingsScreen({
    required this.auth,
    this.onSignIn,
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
              Navigator.of(context).pop();
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
                              onSignIn: widget.onSignIn,
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
                              onSignIn: widget.onSignIn,
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
