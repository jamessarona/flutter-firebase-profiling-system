import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/accountScreen.dart';
import 'package:tanood/screens/assignmentHistoryScreen.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/screens/notificationScreen.dart';
import 'package:tanood/screens/reportsScreen.dart';
import 'package:tanood/screens/violatorsScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/loadingWidgets.dart';
import 'package:tanood/shared/myAppbar.dart';
import 'package:tanood/shared/myBottomSheet.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/myContainers.dart';
import 'package:tanood/shared/myDrawers.dart';
import 'package:tanood/shared/globals.dart';

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

  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;
  var reports;
  var userData;
  var locations;
  final List<String> locationsAdded = [];
  int addLocationCycle = 0;
  String userUID = '';
  late Timer _timer;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void addLocationToList() {
    for (int i = 0; i < locations.length; i++) {
      if (locations[i]['Status'] == 'Active') {
        locationsAdded.insert(0, locations[i]['Name'].toString());
      }
    }
    locationsAdded.sort();
  }

  void saveSelectedArea() async {
    for (int i = 0; i < locations.length; i++) {
      if (locations[i]['Name'] == selectedLocation) {
        await dbRef.child('Tanods').child(userData['TanodId']).update({
          'LocationId': locations[i]['LocationId'].toString(),
        });
      }
    }
  }

  _buildCreateChooseModal(BuildContext context) {
    String tempSelectedArea = selectedLocation;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Set Location',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: DropdownButton<String>(
                value: tempSelectedArea,
                items: locationsAdded
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: secandaryText.copyWith(fontSize: 14),
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    tempSelectedArea = newValue!;
                  });
                },
              ),
              actions: [
                Container(
                  width: 90,
                  child: MyOutlineButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Cancel',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: customColor[140]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 90,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Save',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      selectedLocation = tempSelectedArea;
                      saveSelectedArea();
                      Navigator.pop(context);
                      _buildModalSuccessMessage(context);
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> _buildModalSuccessMessage(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: customColor[130],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: Container(
            height: 100,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You have selected $selectedLocation',
                    style: tertiaryText.copyWith(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  String _getAssignedReportLocation() {
    String reportLocation = '';
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        if (reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['TanodId'] ==
                userData['TanodId'] &&
            reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['Status'] ==
                'Responding')
          reportLocation =
              getLocationName(locations, reports[i]['LocationId'].toString());
      }
    }
    return reportLocation;
  }

  String _getAssignedReportDate() {
    String reportDate = '';
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        if (reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['TanodId'] ==
                userData['TanodId'] &&
            reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['Status'] ==
                'Responding')
          reportDate = reports[i]['AssignedTanod']
                  [reports[i]['AssignedTanod'].length - 1]['DateAssign']
              .toString();
      }
    }
    return reportDate;
  }

  String _getAssignedReportId() {
    String reportId = '';
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        if (reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['TanodId'] ==
                userData['TanodId'] &&
            reports[i]['AssignedTanod'][reports[i]['AssignedTanod'].length - 1]
                    ['Status'] ==
                'Responding') {
          reportId = reports[i]['Id'].toString();
        }
      }
    }
    return reportId;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      getCurrentUserUID().then((valueID) {
        setState(() {
          userUID = valueID;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: userUID.isNotEmpty
          ? StreamBuilder(
              stream: dbRef.child('Locations').onValue,
              builder: (context, locationsSnapshot) {
                if (locationsSnapshot.hasData &&
                    !locationsSnapshot.hasError &&
                    (locationsSnapshot.data! as Event).snapshot.value != null) {
                  locations = (locationsSnapshot.data! as Event).snapshot.value;
                } else {
                  return MyLoadingScreenHomeScreen();
                }
                if (addLocationCycle < 1) {
                  addLocationCycle++;
                  addLocationToList();
                }
                return StreamBuilder(
                    stream: dbRef.child('Tanods').onValue,
                    builder: (context, tanodSnapshot) {
                      if (tanodSnapshot.hasData &&
                          !tanodSnapshot.hasError &&
                          (tanodSnapshot.data! as Event).snapshot.value !=
                              null) {
                        tanods = (tanodSnapshot.data! as Event).snapshot.value;
                      } else {
                        return MyLoadingScreenHomeScreen();
                      }
                      userData =
                          filterCurrentUserInformation(tanods, userUID)[0];
                      if (userData['LocationId'] != null) {
                        selectedLocation =
                            locations[int.parse(userData['LocationId'])]
                                ['Name'];
                      }
                      return StreamBuilder(
                          stream: dbRef.child('Reports').onValue,
                          builder: (context, reportsSnapshot) {
                            if (reportsSnapshot.hasData &&
                                !reportsSnapshot.hasError &&
                                (reportsSnapshot.data! as Event)
                                        .snapshot
                                        .value !=
                                    null) {
                              reports = (reportsSnapshot.data! as Event)
                                  .snapshot
                                  .value;
                            } else {
                              return MyLoadingScreenHomeScreen();
                            }
                            int notifCount = countReportsByLocation(
                                reports, userData['LocationId']);
                            return Scaffold(
                              key: _scaffoldKey,
                              extendBodyBehindAppBar: true,
                              resizeToAvoidBottomInset: false,
                              drawer: BuildDrawer(
                                leading: "Home",
                                auth: widget.auth,
                                onSignOut: widget.onSignOut,
                                userUID: userUID,
                                tanodId: userData['TanodId'],
                                name:
                                    "${userData['Firstname']} ${userData['Lastname']}",
                                email: userData['Email'],
                                profileImage: userData['Image'],
                                backgroundImage:
                                    "https://wallpaperaccess.com/full/1397098.jpg",
                                role: userData['Role'],
                              ),
                              appBar: AppBar(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                leading: MyAppBarLeading(
                                  onPressendDrawer: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                                actions: [
                                  MyAppBarAction(
                                    notifCount: notifCount,
                                    color: Colors.black,
                                    onPressed: () {
                                      Reset.filter();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => NotificationScreen(
                                            tanodId: userData['TanodId'],
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              body: Container(
                                height: screenSize.height,
                                width: screenSize.width,
                                color: customColor[110],
                                child: ListView(
                                  children: [
                                    MyUserDetail(
                                        image: userData['Image'],
                                        firstname: userData['Firstname'],
                                        onTap: () {
                                          _buildCreateChooseModal(context);
                                        }),
                                    MyStatusCard(
                                      status: userData['Status'],
                                      location: _getAssignedReportLocation(),
                                      date: _getAssignedReportDate(),
                                      onTap: () {
                                        if (userData['Status'] != "Standby") {
                                          print("Load Specific Report");
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  DetailReportScreen(
                                                id: _getAssignedReportId(),
                                                isFromNotification: false,
                                                auth: widget.auth,
                                                onSignOut: widget.onSignOut,
                                              ),
                                            ),
                                          );
                                        } else {
                                          print("Load Reports");
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (ctx) => ReportsScreen(
                                                auth: widget.auth,
                                                onSignOut: widget.onSignOut,
                                                email: userData['Email'],
                                                userUID: userUID,
                                                tanodId: userData['TanodId'],
                                                name:
                                                    "${userData['Firstname']} ${userData['Lastname']}",
                                                profileImage: userData['Image'],
                                                defaultIndex: 0,
                                                role: userData['Role'],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 30,
                                        left: 20,
                                        right: 20,
                                      ),
                                      width: screenSize.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 4,
                                              bottom: 15,
                                            ),
                                            child: Text(
                                              "Information",
                                              style: tertiaryText.copyWith(
                                                  fontSize: 16,
                                                  letterSpacing: 0),
                                            ),
                                          ),
                                          MyInformationCard(
                                            icon: 'folder.png',
                                            text: "Assignment History",
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AssignmentHistoryScreen(
                                                    userUID: userUID,
                                                    auth: widget.auth,
                                                    onSignOut: widget.onSignOut,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          MyInformationCard(
                                            icon: 'suspect.png',
                                            text: "Violators",
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      ViolatorsScreen(
                                                    auth: widget.auth,
                                                    onSignOut: widget.onSignOut,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          MyInformationCard(
                                            icon: 'user.png',
                                            text: "My Account",
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      MyAccountScreen(
                                                    userUID: userUID,
                                                    auth: widget.auth,
                                                    onSignOut: widget.onSignOut,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Container(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              })
          : MyLoadingScreenHomeScreen(),
    );
  }
}
