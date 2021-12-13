import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
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
      extendBodyBehindAppBar: true,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: screenSize.height / 13),
              margin: EdgeInsets.only(right: screenSize.width * .001),
              height: screenSize.height * .135,
              width: screenSize.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.bars,
                        size: 20,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      }),
                  IconButton(
                      icon: Badge(
                        badgeContent:
                            Text('5', style: TextStyle(color: Colors.white)),
                        child: Icon(
                          FontAwesomeIcons.bell,
                          size: 22,
                        ),
                      ),
                      onPressed: () {}),
                ],
              ),
            ),
            Container(
              height: screenSize.height * .101,
              width: screenSize.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: screenSize.height / 10,
                    width: screenSize.width / 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: customColor[40],
                    ),
                  ),
                  Positioned(
                    left: screenSize.width * .42,
                    child: Container(
                      height: screenSize.height / 10,
                      width: screenSize.width / 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: customColor[50],
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://images.newscientist.com/wp-content/uploads/2021/02/05110628/bill-gates-author-photo_web.jpg",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenSize.height / 90,
                left: screenSize.width / 20,
                right: screenSize.width / 13,
              ),
              height: screenSize.height * .101,
              width: screenSize.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: screenSize.height * .101,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: tertiaryText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'James Angelo',
                          style: secandaryText.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'welcome back!',
                          style: tertiaryText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.height * .101,
                    child: GestureDetector(
                      onTap: () {
                        print('Location is Pressed');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.streetView,
                            color: customColor[80],
                          ),
                          Container(
                            height: screenSize.height / 90,
                          ),
                          Text(
                            ' Silver St. D.C ',
                            style: tertiaryText.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    color: Colors.blueGrey,
                                    offset: Offset(0, -4))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: customColor[60],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenSize.height / 45),
              padding: EdgeInsets.only(
                top: screenSize.height / 26,
                bottom: screenSize.height / 35,
                left: screenSize.height / 35,
                right: screenSize.height / 35,
              ),
              height: screenSize.height * .24,
              width: screenSize.width * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff9030f4),
                    Color(0xff4243e6),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Status,',
                              style: tertiaryText.copyWith(
                                  fontSize: 15, color: Colors.white70),
                            ),
                            Container(
                              height: screenSize.height / 80,
                            ),
                            Text.rich(
                              TextSpan(
                                style: tertiaryText.copyWith(
                                    fontSize: 19, color: Colors.white),
                                children: [
                                  TextSpan(text: 'Responding to\n'),
                                  TextSpan(
                                    text: 'Silver Street, D.C.',
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${calculateTimeOfOccurence("2021-12-13 21:49:12")}",
                              style: tertiaryText.copyWith(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Respond as quickly as possible',
                        style: tertiaryText.copyWith(
                            fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpinKitPouringHourGlassRefined(
                        color: Color(0xfff09a1c),
                        size: 50,
                        strokeWidth: 1,
                      ),
                      Icon(
                        FontAwesomeIcons.angleDoubleRight,
                        size: 25,
                        color: Colors.white70,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenSize.height / 30,
                left: screenSize.width / 50,
                right: screenSize.width / 50,
              ),
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.width / 70,
                        bottom: screenSize.height / 80),
                    child: Text(
                      "Information",
                      style:
                          tertiaryText.copyWith(fontSize: 16, letterSpacing: 0),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.solidFolderOpen,
                        color: customColor[100],
                      ),
                      title: Text('Assignment History'),
                      trailing: Icon(FontAwesomeIcons.chevronRight),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.users,
                        color: customColor[100],
                      ),
                      title: Text('Violators'),
                      trailing: Icon(FontAwesomeIcons.chevronRight),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.userAlt,
                        color: customColor[100],
                      ),
                      title: Text('My Account'),
                      trailing: Icon(FontAwesomeIcons.chevronRight),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//for standby font awesome
//periscope