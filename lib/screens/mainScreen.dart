import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
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
          color: customColor[20],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: screenSize.height / 12),
                height: screenSize.height * .13,
                width: screenSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(FontAwesomeIcons.bars),
                    ),
                    Badge(
                      position: BadgePosition.topEnd(top: 1, end: 2),
                      badgeContent: Text(
                        '11',
                        style: tertiaryText.copyWith(fontSize: 11),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.bell),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: screenSize.height * .02,
                      left: screenSize.width * .03,
                      right: screenSize.width * .03),
                  width: screenSize.width,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Container(
                        height: screenSize.height * 0.404,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              spreadRadius: 0.0,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Container(
                                height: screenSize.height * 0.33,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        FontAwesomeIcons.award,
                                        color: Colors.yellow[800],
                                      ),
                                      title: Align(
                                        alignment: Alignment(-1.2, 0),
                                        child: Text(
                                          'Summary',
                                          style: secandaryText.copyWith(
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MySummaryCard(
                                            icon: FontAwesomeIcons.headSideMask,
                                            label: "Caught",
                                            number: 5),
                                        MySummaryCard(
                                            icon: FontAwesomeIcons.running,
                                            label: "Fled",
                                            number: 8),
                                        MySummaryCard(
                                            icon: FontAwesomeIcons.users,
                                            label: "Total Reports",
                                            number: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('click');
                              },
                              child: ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.fileAlt,
                                ),
                                title: Align(
                                  alignment: Alignment(-1.4, 0),
                                  child: Text(
                                    'See Recorded Reports',
                                    style: tertiaryText.copyWith(fontSize: 15),
                                  ),
                                ),
                                trailing:
                                    Icon(FontAwesomeIcons.angleDoubleRight),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: screenSize.height * .03,
                      ),
                      Container(
                        height: screenSize.height * .05,
                        width: screenSize.width,
                        color: Colors.blue,
                        child: Row(
                          children: [
                            Text('Buttons/Filters'),
                          ],
                        ),
                      ),
                      Container(
                        height: screenSize.height * .3,
                        width: screenSize.width,
                        color: Colors.red,
                        child: Text('Graph'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
