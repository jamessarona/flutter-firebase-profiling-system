import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class MyAccountScreen extends StatefulWidget {
  final String userUID;
  const MyAccountScreen({required this.userUID});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;
  var userData;
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
            'My Account',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder(
            stream: dbRef.child('Tanods').onValue,
            builder: (context, tanodSnapshot) {
              if (tanodSnapshot.hasData &&
                  !tanodSnapshot.hasError &&
                  (tanodSnapshot.data! as Event).snapshot.value != null) {
                tanods = (tanodSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              userData =
                  filterCurrentUserInformation(tanods, widget.userUID)[0];
              return Container(
                height: screenSize.height,
                width: screenSize.width,
                child: ListView(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        userData['Image'] == 'default'
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: customColor[130],
                                ),
                                child: Image.asset(
                                  "assets/images/default.png",
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: customColor[130],
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      userData['Image'],
                                    ),
                                  ),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.only(left: 60, top: 60),
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print('object');
                            },
                            child: Icon(
                              FontAwesomeIcons.camera,
                              color: customColor[130],
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 4,
                              bottom: 5,
                            ),
                            child: Text(
                              'User Information',
                              style: tertiaryText.copyWith(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  color: Colors.grey[800]),
                            ),
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Firstname", value: userData['Firstname'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Lastname", value: userData['Lastname'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Email", value: userData['Email'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Birthday",
                            value:
                                '${setDateTime(userData['Birthday'], 'Date')} / (${calculateAge(userData['Birthday'])})',
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Gender", value: userData['Gender'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Contact", value: userData['Contact'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                          MyAccountInformationCard(
                            icon: 'group.png',
                            //  Icon(
                            //   FontAwesomeIcons.folderOpen,
                            //   color: customColor[130],
                            // ),
                            title: "Address", value: userData['Address'],
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => TanodsStatusScreen(),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
