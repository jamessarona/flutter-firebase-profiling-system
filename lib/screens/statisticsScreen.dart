import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/notificationScreen.dart';
import 'package:tanood/screens/reportsScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/globals.dart';
import 'package:tanood/shared/loadingWidgets.dart';
import 'package:tanood/shared/myAppbar.dart';
import 'package:tanood/shared/myBottomSheet.dart';
import 'package:tanood/shared/myButtons.dart';
import 'package:tanood/shared/myContainers.dart';
import 'package:tanood/shared/myDrawers.dart';
import 'package:tanood/shared/myListTile.dart';
import 'package:tanood/shared/mySpinKits.dart';
import 'package:tanood/shared/myText.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userUID;
  final String tanodId;
  final String name;
  final String email;
  final String profileImage;
  final String role;
  const StatisticsScreen({
    required this.auth,
    required this.onSignOut,
    required this.userUID,
    required this.tanodId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.role,
  });

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKeyStatistics = GlobalKey<ScaffoldState>();
  late Size screenSize;
  var reports;
  var latestReports;
  var droppedReports;
  var taggedReports;
  var locations;
  var userData;
  int notifCount = 0;
  var formatter = NumberFormat('#,##,#00');
  final dbRef = FirebaseDatabase.instance.reference();
  String visualTipMessage =
      "The graph below represents the estimated average number of violators per category eg. hour, day, and month.";
  String selectedFilter = "Filter Result";
  String selectedLabel = 'Hour';
  String chartTitle = 'Estimated Violators/Hour';
  String methodTitle = 'AVG';
  String selectedMonth = '';
  List<Color> gradientColor = [
    Color(0xffadb1ea),
    Color(0xff1c52dd),
  ];
  int selectedCategory = 1;
  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  int _calculateTotalViolatorsCount() {
    num violatorCount = 0;
    if (latestReports.isNotEmpty) {
      for (int i = 0; i < latestReports[0].length; i++) {
        violatorCount += latestReports[0][i]['ViolatorCount'];
      }
    }
    if (droppedReports.isNotEmpty) {
      for (int i = 0; i < droppedReports[0].length; i++) {
        num tempCount = 0;
        if (droppedReports[0][i]['AssignedTanod']
                        [droppedReports[0][i]['AssignedTanod'].length - 1]
                    ['Reason'] ==
                'Duplicate' ||
            droppedReports[0][i]['AssignedTanod']
                        [droppedReports[0][i]['AssignedTanod'].length - 1]
                    ['Reason'] ==
                'Not a person') {
          for (int x = 0;
              x < droppedReports[0][i]['AssignedTanod'].length;
              x++) {
            if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                null) {
              tempCount += droppedReports[0][i]['AssignedTanod'][x]
                      ['Documentation']
                  .length;
            }
          }
          if (tempCount > 0) {
            violatorCount +=
                (droppedReports[0][i]['ViolatorCount'] - tempCount);
          }
        } else {
          violatorCount += droppedReports[0][i]['ViolatorCount'];
        }
      }
    }
    if (taggedReports.isNotEmpty) {
      for (int i = 0; i < taggedReports[0].length; i++) {
        violatorCount += taggedReports[0][i]['ViolatorCount'];
      }
    }
    return violatorCount.toInt();
  }

  int _calculateDocumentedViolator() {
    num violatorCount = 0;
    if (latestReports.isNotEmpty) {
      for (int i = 0; i < latestReports[0].length; i++) {
        if (latestReports[0][i]['AssignedTanod'] != null) {
          for (int x = 0;
              x < latestReports[0][i]['AssignedTanod'].length;
              x++) {
            if (latestReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                null) {
              violatorCount += latestReports[0][i]['AssignedTanod'][x]
                      ['Documentation']
                  .length;
            }
          }
        }
      }
    }
    if (droppedReports.isNotEmpty) {
      for (int i = 0; i < droppedReports[0].length; i++) {
        if (droppedReports[0][i]['AssignedTanod'] != null) {
          for (int x = 0;
              x < droppedReports[0][i]['AssignedTanod'].length;
              x++) {
            if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                null) {
              violatorCount += droppedReports[0][i]['AssignedTanod'][x]
                      ['Documentation']
                  .length;
            }
          }
        }
      }
    }
    if (taggedReports.isNotEmpty) {
      for (int i = 0; i < taggedReports[0].length; i++) {
        if (taggedReports[0][i]['AssignedTanod'] != null) {
          for (int x = 0;
              x < taggedReports[0][i]['AssignedTanod'].length;
              x++) {
            if (taggedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                null) {
              violatorCount += taggedReports[0][i]['AssignedTanod'][x]
                      ['Documentation']
                  .length;
            }
          }
        }
      }
    }
    return violatorCount.toInt();
  }

  int _calculateEscapedViolator() {
    num documentedCount = 0;
    num violatorCount = 0;
    if (droppedReports.isNotEmpty) {
      for (int i = 0; i < droppedReports[0].length; i++) {
        documentedCount = 0;
        if (droppedReports[0][i]['AssignedTanod'] != null) {
          for (int x = 0;
              x < droppedReports[0][i]['AssignedTanod'].length;
              x++) {
            if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                null) {
              documentedCount += droppedReports[0][i]['AssignedTanod'][x]
                      ['Documentation']
                  .length;
            }
            if (x == droppedReports[0][i]['AssignedTanod'].length - 1 &&
                droppedReports[0][i]['AssignedTanod'][x]['Reason'] ==
                    'Violator Escaped') {
              violatorCount +=
                  droppedReports[0][i]['ViolatorCount'] - documentedCount;
            }
          }
        }
      }
    }
    return violatorCount.toInt();
  }

  int _calculateReportCount(String category) {
    int reportCount = 0;
    if (category == "Latest") {
      if (latestReports.isNotEmpty) {
        for (int i = 0; i < latestReports[0].length; i++) {
          if (latestReports[0][i]['AssignedTanod'] == null) {
            reportCount++;
          }
        }
      }
    } else {
      if (droppedReports.isNotEmpty) {
        for (int i = 0; i < droppedReports[0].length; i++) {
          if (droppedReports[0][i]['AssignedTanod']
                      [droppedReports[0][i]['AssignedTanod'].length - 1]
                  ['Status'] ==
              'Dropped') {
            reportCount++;
          }
        }
      }
    }
    return reportCount;
  }

  int _calculteOverallReportCount(String category) {
    int reportCount = 0;
    if (category == "Latest") {
      if (latestReports.isNotEmpty) {
        for (int i = 0; i < latestReports[0].length; i++) {
          reportCount++;
        }
      }
    } else {
      if (droppedReports.isNotEmpty) {
        for (int i = 0; i < droppedReports[0].length; i++) {
          reportCount++;
        }
      }
    }
    return reportCount;
  }

  double _calculateReportsCount(String dateKind, int position, String method) {
    double value = 0;
    if (dateKind == 'Hour') {
      int defaultTime = 5;
      if (selectedCategory == 2) {
        defaultTime = 12;
      }

      if (latestReports.isNotEmpty) {
        for (int i = 0; i < latestReports[0].length; i++) {
          DateTime date = DateTime.parse(latestReports[0][i]['Date']);
          if (date.hour == position + defaultTime) {
            value += latestReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (droppedReports.isNotEmpty) {
        for (int i = 0; i < droppedReports[0].length; i++) {
          DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
          if (date.hour == position + defaultTime) {
            num tempCount = 0;
            if (droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Duplicate' ||
                droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Not a person') {
              for (int x = 0;
                  x < droppedReports[0][i]['AssignedTanod'].length;
                  x++) {
                if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                    null) {
                  tempCount += droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation']
                      .length;
                }
              }
              if (tempCount > 0) {
                value += (droppedReports[0][i]['ViolatorCount'] - tempCount);
              }
            } else {
              value += droppedReports[0][i]['ViolatorCount'];
            }
            //value += droppedReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (taggedReports.isNotEmpty) {
        for (int i = 0; i < taggedReports[0].length; i++) {
          DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
          if (date.hour == position + defaultTime) {
            value += taggedReports[0][i]['ViolatorCount'];
          }
        }
      }
    } else if (dateKind == 'Day') {
      if (latestReports.isNotEmpty) {
        for (int i = 0; i < latestReports[0].length; i++) {
          DateTime date = DateTime.parse(latestReports[0][i]['Date']);
          if (date.weekday - 1 == position) {
            value += latestReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (droppedReports.isNotEmpty) {
        for (int i = 0; i < droppedReports[0].length; i++) {
          DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
          if (date.weekday - 1 == position) {
            num tempCount = 0;
            if (droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Duplicate' ||
                droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Not a person') {
              for (int x = 0;
                  x < droppedReports[0][i]['AssignedTanod'].length;
                  x++) {
                if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                    null) {
                  tempCount += droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation']
                      .length;
                }
              }
              if (tempCount > 0) {
                value += (droppedReports[0][i]['ViolatorCount'] - tempCount);
              }
            } else {
              value += droppedReports[0][i]['ViolatorCount'];
            }
            //value += droppedReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (taggedReports.isNotEmpty) {
        for (int i = 0; i < taggedReports[0].length; i++) {
          DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
          if (date.weekday - 1 == position) {
            value += taggedReports[0][i]['ViolatorCount'];
          }
        }
      }
    } else {
      int defaultTime = 1;
      if (selectedCategory == 2) {
        defaultTime = 7;
      }
      if (latestReports.isNotEmpty) {
        for (int i = 0; i < latestReports[0].length; i++) {
          DateTime date = DateTime.parse(latestReports[0][i]['Date']);
          if (date.month == position + defaultTime) {
            value += latestReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (droppedReports.isNotEmpty) {
        for (int i = 0; i < droppedReports[0].length; i++) {
          DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
          if (date.month == position + defaultTime) {
            num tempCount = 0;
            if (droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Duplicate' ||
                droppedReports[0][i]['AssignedTanod']
                            [droppedReports[0][i]['AssignedTanod'].length - 1]
                        ['Reason'] ==
                    'Not a person') {
              for (int x = 0;
                  x < droppedReports[0][i]['AssignedTanod'].length;
                  x++) {
                if (droppedReports[0][i]['AssignedTanod'][x]['Documentation'] !=
                    null) {
                  tempCount += droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation']
                      .length;
                }
              }
              if (tempCount > 0) {
                value += (droppedReports[0][i]['ViolatorCount'] - tempCount);
              }
            } else {
              value += droppedReports[0][i]['ViolatorCount'];
            }
            //value += droppedReports[0][i]['ViolatorCount'];
          }
        }
      }
      if (taggedReports.isNotEmpty) {
        for (int i = 0; i < taggedReports[0].length; i++) {
          DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
          if (date.month == position + defaultTime) {
            value += taggedReports[0][i]['ViolatorCount'];
          }
        }
      }
    }
    return value;
  }

  double _calculateGreatestNumber(String dateKind) {
    double maxYAxis = 10;
    double tempYAxis = 0;
    if (dateKind == 'Hour') {
      int defaultTime = 4;
      if (selectedCategory == 2) {
        defaultTime = 11;
      }
      for (int x = 1; x <= 7; x++) {
        tempYAxis = 0;
        if (latestReports.isNotEmpty) {
          for (int i = 0; i < latestReports[0].length; i++) {
            DateTime date = DateTime.parse(latestReports[0][i]['Date']);
            if (date.hour == x + defaultTime) {
              tempYAxis += latestReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (droppedReports.isNotEmpty) {
          for (int i = 0; i < droppedReports[0].length; i++) {
            DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
            if (date.hour == x + defaultTime) {
              num tempCount = 0;
              if (droppedReports[0][i]['AssignedTanod']
                          [droppedReports[0][i]['AssignedTanod'].length - 1]
                      ['Reason'] ==
                  'Duplicate') {
                for (int x = 0;
                    x < droppedReports[0][i]['AssignedTanod'].length;
                    x++) {
                  if (droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation'] !=
                      null) {
                    tempCount += droppedReports[0][i]['AssignedTanod'][x]
                            ['Documentation']
                        .length;
                  }
                }
                if (tempCount > 0) {
                  tempYAxis +=
                      (droppedReports[0][i]['ViolatorCount'] - tempCount);
                }
              } else {
                tempYAxis += droppedReports[0][i]['ViolatorCount'];
              }
              // tempYAxis += droppedReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (taggedReports.isNotEmpty) {
          for (int i = 0; i < taggedReports[0].length; i++) {
            DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
            if (date.hour == x + defaultTime) {
              tempYAxis += taggedReports[0][i]['ViolatorCount'];
            }
          }
        }

        if (tempYAxis > maxYAxis) {
          maxYAxis = tempYAxis;
        }
      }
    } else if (dateKind == 'Day') {
      int defaultTime = 0;
      for (int x = 1; x <= 7; x++) {
        tempYAxis = 0;
        if (latestReports.isNotEmpty) {
          for (int i = 0; i < latestReports[0].length; i++) {
            DateTime date = DateTime.parse(latestReports[0][i]['Date']);
            if (date.weekday == x + defaultTime) {
              tempYAxis += latestReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (droppedReports.isNotEmpty) {
          for (int i = 0; i < droppedReports[0].length; i++) {
            DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
            if (date.weekday == x + defaultTime) {
              num tempCount = 0;
              if (droppedReports[0][i]['AssignedTanod']
                          [droppedReports[0][i]['AssignedTanod'].length - 1]
                      ['Reason'] ==
                  'Duplicate') {
                for (int x = 0;
                    x < droppedReports[0][i]['AssignedTanod'].length;
                    x++) {
                  if (droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation'] !=
                      null) {
                    tempCount += droppedReports[0][i]['AssignedTanod'][x]
                            ['Documentation']
                        .length;
                  }
                }
                if (tempCount > 0) {
                  tempYAxis +=
                      (droppedReports[0][i]['ViolatorCount'] - tempCount);
                }
              } else {
                tempYAxis += droppedReports[0][i]['ViolatorCount'];
              }
              // tempYAxis += droppedReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (taggedReports.isNotEmpty) {
          for (int i = 0; i < taggedReports[0].length; i++) {
            DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
            if (date.weekday == x + defaultTime) {
              tempYAxis += taggedReports[0][i]['ViolatorCount'];
            }
          }
        }

        if (tempYAxis > maxYAxis) {
          maxYAxis = tempYAxis;
        }
      }
    } else {
      int defaultTime = 0;
      if (selectedCategory == 2) {
        defaultTime = 6;
      }
      for (int x = 1; x <= 7; x++) {
        tempYAxis = 0;
        if (latestReports.isNotEmpty) {
          for (int i = 0; i < latestReports[0].length; i++) {
            DateTime date = DateTime.parse(latestReports[0][i]['Date']);
            if (date.month == x + defaultTime) {
              tempYAxis += latestReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (droppedReports.isNotEmpty) {
          for (int i = 0; i < droppedReports[0].length; i++) {
            DateTime date = DateTime.parse(droppedReports[0][i]['Date']);
            if (date.month == x + defaultTime) {
              num tempCount = 0;
              if (droppedReports[0][i]['AssignedTanod']
                          [droppedReports[0][i]['AssignedTanod'].length - 1]
                      ['Reason'] ==
                  'Duplicate') {
                for (int x = 0;
                    x < droppedReports[0][i]['AssignedTanod'].length;
                    x++) {
                  if (droppedReports[0][i]['AssignedTanod'][x]
                          ['Documentation'] !=
                      null) {
                    tempCount += droppedReports[0][i]['AssignedTanod'][x]
                            ['Documentation']
                        .length;
                  }
                }
                if (tempCount > 0) {
                  tempYAxis +=
                      (droppedReports[0][i]['ViolatorCount'] - tempCount);
                }
              } else {
                tempYAxis += droppedReports[0][i]['ViolatorCount'];
              }
              // tempYAxis += droppedReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (taggedReports.isNotEmpty) {
          for (int i = 0; i < taggedReports[0].length; i++) {
            DateTime date = DateTime.parse(taggedReports[0][i]['Date']);
            if (date.month == x + defaultTime) {
              tempYAxis += taggedReports[0][i]['ViolatorCount'];
            }
          }
        }
        if (tempYAxis > maxYAxis) {
          maxYAxis = tempYAxis;
        }
      }
    }
    return maxYAxis;
  }

  double _setInterval(double maxYNumber) {
    return maxYNumber * .25;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: dbRef.child('Tanods').child(widget.tanodId).onValue,
          builder: (context, userDataSnapshot) {
            if (userDataSnapshot.hasData &&
                !userDataSnapshot.hasError &&
                (userDataSnapshot.data! as Event).snapshot.value != null) {
              userData = (userDataSnapshot.data! as Event).snapshot.value;
            } else {
              return Scaffold(
                body: Center(
                  child: MySpinKitLoadingScreen(),
                ),
              );
            }

            return StreamBuilder(
                stream: dbRef.child('Reports').onValue,
                builder: (context, reportsSnapshot) {
                  if (reportsSnapshot.hasData &&
                      !reportsSnapshot.hasError &&
                      (reportsSnapshot.data! as Event).snapshot.value != null) {
                    reports = (reportsSnapshot.data! as Event).snapshot.value;
                  } else {
                    return Scaffold(
                      body: Center(
                        child: MySpinKitLoadingScreen(),
                      ),
                    );
                  }
                  notifCount =
                      countReportsByLocation(reports, userData['LocationId']);
                  latestReports = filterReport("Latest", reports);
                  droppedReports = filterReport("Dropped", reports);
                  taggedReports = filterReport("Tagged", reports);

                  return StreamBuilder<Object>(
                      stream: dbRef.child('Locations').onValue,
                      builder: (context, locationsSnapshot) {
                        if (locationsSnapshot.hasData &&
                            !locationsSnapshot.hasError &&
                            (locationsSnapshot.data! as Event).snapshot.value !=
                                null) {
                          locations =
                              (locationsSnapshot.data! as Event).snapshot.value;
                        } else {
                          return MyLoadingScreenHomeScreen();
                        }
                        return Scaffold(
                          key: _scaffoldKeyStatistics,
                          drawer: BuildDrawer(
                            leading: "Statistics",
                            auth: widget.auth,
                            onSignOut: widget.onSignOut,
                            userUID: widget.userUID,
                            tanodId: widget.tanodId,
                            name: widget.name,
                            email: widget.email,
                            profileImage: widget.profileImage,
                            backgroundImage:
                                "https://wallpaperaccess.com/full/1397098.jpg",
                            role: widget.role,
                          ),
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            leading: MyAppBarLeading(
                              onPressendDrawer: () {
                                _scaffoldKeyStatistics.currentState!
                                    .openDrawer();
                              },
                            ),
                            centerTitle: true,
                            title: Text(
                              'Statistics',
                              style: primaryText.copyWith(
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
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
                              ),
                            ],
                          ),
                          body: Container(
                            height: screenSize.height,
                            width: screenSize.width,
                            color: customColor[110],
                            child: ListView(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 15,
                                    left: screenSize.width * .1,
                                    right: screenSize.width * .1,
                                  ),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: customColor[110],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: customColor[110],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(50),
                                          ),
                                        ),
                                        builder: (context) => BuildBottomSheet(
                                          page: 'Statistics',
                                        ),
                                      ).then((value) => setState(() {}));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          size: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width / 80),
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: screenSize.width * .45,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                15,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            filters['Category']['Latest'] ||
                                                    filters['Category']
                                                        ['Dropped'] ||
                                                    filters['Category']
                                                        ['Tagged'] ||
                                                    filters['Date']['Start'] ||
                                                    filters['Date']['End'] ||
                                                    filters['Area']
                                                        ['Tarape\'s Store'] ||
                                                    filters['Area']
                                                        ['ShopStrutt.ph'] ||
                                                    filters['Area']
                                                        ['Melchor\'s Store']
                                                ? 'Filtered Results'
                                                : selectedFilter,
                                            style: tertiaryText.copyWith(
                                                fontSize: 15,
                                                color: Colors.grey[800]),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.slidersH,
                                          size: 20,
                                          color: filters['Category']
                                                      ['Latest'] ||
                                                  filters['Category']
                                                      ['Dropped'] ||
                                                  filters['Category']
                                                      ['Tagged'] ||
                                                  filters['Date']['Start'] ||
                                                  filters['Date']['End'] ||
                                                  filters['Area']
                                                      ['Tarape\'s Store'] ||
                                                  filters['Area']
                                                      ['ShopStrutt.ph'] ||
                                                  filters['Area']
                                                      ['Melchor\'s Store']
                                              ? customColor[170]
                                              : Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  height: 60,
                                  width: screenSize.width,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Estimated Total Violations',
                                        style:
                                            tertiaryText.copyWith(fontSize: 18),
                                      ),
                                      Text(
                                        '${formatter.format(_calculateTotalViolatorsCount())}',
                                        style: tertiaryText.copyWith(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 150,
                                  width: screenSize.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyStatisticsCountsContainer(
                                        title: 'Documented',
                                        count: _calculateDocumentedViolator(),
                                      ),
                                      Container(
                                        width: screenSize.width * .03,
                                      ),
                                      MyStatisticsCountsContainer(
                                        title: 'Escaped',
                                        count: _calculateEscapedViolator(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 30,
                                    left: screenSize.width * 0.05,
                                    right: screenSize.width * 0.05,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Visualization',
                                        style: tertiaryText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Tooltip(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width * .2),
                                          message: visualTipMessage,
                                          textStyle: tertiaryText.copyWith(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.questionCircle,
                                            size: 15,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                    left: screenSize.width * .1,
                                    right: screenSize.width * .1,
                                  ),
                                  height: 30,
                                  width: screenSize.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MyDateLabel(
                                        title: 'Hour',
                                        onTap: () {
                                          setState(() {
                                            selectedLabel = 'Hour';
                                            chartTitle =
                                                'Estimated Violators/Hour';
                                            selectedCategory = 1;
                                            // 5-11am
                                            // 12-6pm
                                          });
                                        },
                                        selectedLabel: selectedLabel,
                                      ),
                                      MyDateLabel(
                                        title: 'Day',
                                        onTap: () {
                                          setState(() {
                                            selectedLabel = 'Day';
                                            chartTitle =
                                                'Estimated Violators/Day';
                                          });
                                        },
                                        selectedLabel: selectedLabel,
                                      ),
                                      MyDateLabel(
                                        title: 'Month',
                                        onTap: () {
                                          setState(() {
                                            selectedLabel = 'Month';
                                            chartTitle =
                                                'Estimated Violators/Month';
                                            selectedCategory = 1;
                                          });
                                        },
                                        selectedLabel: selectedLabel,
                                      ),
                                    ],
                                  ),
                                ),
                                selectedLabel != 'Day'
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: 15,
                                          bottom: 10,
                                          left: screenSize.width * 0.05,
                                          right: screenSize.width * 0.05,
                                        ),
                                        height: 30,
                                        width: screenSize.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyOutlineButton(
                                              elavation: 5,
                                              color: selectedCategory == 1
                                                  ? Color(0xff1c52dd)
                                                  : Colors.grey,
                                              radius: 10,
                                              onPressed: () {
                                                setState(() {
                                                  selectedCategory = 1;
                                                });
                                              },
                                              isLoading: false,
                                              text: Text(
                                                selectedLabel == 'Hour'
                                                    ? 'AM'
                                                    : 'Q1 & Q2',
                                              ),
                                            ),
                                            Container(
                                              width: 5,
                                            ),
                                            MyOutlineButton(
                                              elavation: 5,
                                              color: selectedCategory == 2
                                                  ? Color(0xff1c52dd)
                                                  : Colors.grey,
                                              radius: 10,
                                              onPressed: () {
                                                setState(() {
                                                  selectedCategory = 2;
                                                });
                                              },
                                              isLoading: false,
                                              text: Text(
                                                selectedLabel == 'Hour'
                                                    ? 'PM'
                                                    : 'Q3 & Q4',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: screenSize.width * 0.05,
                                          right: screenSize.width * 0.05,
                                        ),
                                      ),
                                Container(
                                  child: Text(
                                    chartTitle,
                                    style: tertiaryText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                    left: screenSize.width * 0.03,
                                    right: screenSize.width * 0.03,
                                  ),
                                  height: 300,
                                  width: screenSize.width,
                                  child: selectedLabel != 'Month'
                                      ? BarChart(
                                          BarChartData(
                                            alignment:
                                                BarChartAlignment.spaceEvenly,
                                            maxY: _calculateGreatestNumber(
                                                selectedLabel),
                                            minY: 0,
                                            groupsSpace: 12,
                                            axisTitleData: FlAxisTitleData(
                                              show: true,
                                              bottomTitle: AxisTitle(
                                                showTitle: true,
                                                titleText: selectedLabel,
                                                textStyle:
                                                    tertiaryText.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              leftTitle: AxisTitle(
                                                showTitle: true,
                                                titleText: 'Violators',
                                                textStyle:
                                                    tertiaryText.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              topTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                              bottomTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles:
                                                    (context, value) =>
                                                        const TextStyle(
                                                            fontSize: 10),
                                                margin: 10,
                                                rotateAngle: 0,
                                                getTitles: (double value) {
                                                  if (selectedLabel == 'Hour') {
                                                    if (selectedCategory == 1) {
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          return '5am';
                                                        case 1:
                                                          return '6am';
                                                        case 2:
                                                          return '7am';
                                                        case 3:
                                                          return '8am';
                                                        case 4:
                                                          return '9am';
                                                        case 5:
                                                          return '10am';
                                                        case 6:
                                                          return '11am';
                                                        default:
                                                          return '';
                                                      }
                                                    } else {
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          return '12pm';
                                                        case 1:
                                                          return '1pm';
                                                        case 2:
                                                          return '2pm';
                                                        case 3:
                                                          return '3pm';
                                                        case 4:
                                                          return '4pm';
                                                        case 5:
                                                          return '5pm';
                                                        case 6:
                                                          return '6pm';
                                                        default:
                                                          return '';
                                                      }
                                                    }
                                                  } else {
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return 'Mon';
                                                      case 1:
                                                        return 'Tue';
                                                      case 2:
                                                        return 'Wed';
                                                      case 3:
                                                        return 'Thu';
                                                      case 4:
                                                        return 'Fri';
                                                      case 5:
                                                        return 'Sat';
                                                      case 6:
                                                        return 'Sun';
                                                      default:
                                                        return '';
                                                    }
                                                  }
                                                },
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles:
                                                    (context, value) =>
                                                        const TextStyle(
                                                            fontSize: 10),
                                                rotateAngle: 0,
                                                getTitles: (double value) {
                                                  return '${value.toInt()}';
                                                },
                                                interval: _setInterval(
                                                    _calculateGreatestNumber(
                                                        selectedLabel)),
                                                margin: 8,
                                                reservedSize: 30,
                                              ),
                                              rightTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: false,
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            barGroups: [
                                              BarChartGroupData(
                                                x: 0,
                                                barRods: [
                                                  BarChartRodData(
                                                    colors: gradientColor,
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        0,
                                                        methodTitle),
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 1,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        1,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 2,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        2,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 3,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        3,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 4,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        4,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 5,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        5,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 6,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        6,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : BarChart(
                                          BarChartData(
                                            alignment:
                                                BarChartAlignment.spaceEvenly,
                                            maxY: _calculateGreatestNumber(
                                                selectedLabel),
                                            minY: 0,
                                            groupsSpace: 12,
                                            axisTitleData: FlAxisTitleData(
                                              show: true,
                                              bottomTitle: AxisTitle(
                                                showTitle: true,
                                                titleText: selectedLabel,
                                                textStyle:
                                                    tertiaryText.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              leftTitle: AxisTitle(
                                                showTitle: true,
                                                titleText: 'Violators',
                                                textStyle:
                                                    tertiaryText.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              topTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                              bottomTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles:
                                                    (context, value) =>
                                                        const TextStyle(
                                                            fontSize: 10),
                                                margin: 10,
                                                rotateAngle: 0,
                                                getTitles: (double value) {
                                                  if (selectedCategory == 1) {
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return 'Jan';
                                                      case 1:
                                                        return 'Feb';
                                                      case 2:
                                                        return 'Mar';
                                                      case 3:
                                                        return 'Apr';
                                                      case 4:
                                                        return 'May';
                                                      case 5:
                                                        return 'Jun';
                                                      default:
                                                        return '';
                                                    }
                                                  } else {
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return 'Jul';
                                                      case 1:
                                                        return 'Aug';
                                                      case 2:
                                                        return 'Sep';
                                                      case 3:
                                                        return 'Oct';
                                                      case 4:
                                                        return 'Nov';
                                                      case 5:
                                                        return 'Dec';
                                                      default:
                                                        return '';
                                                    }
                                                  }
                                                },
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles:
                                                    (context, value) =>
                                                        const TextStyle(
                                                            fontSize: 10),
                                                rotateAngle: 0,
                                                getTitles: (double value) {
                                                  return '${value.toInt()}';
                                                },
                                                interval: _setInterval(
                                                    _calculateGreatestNumber(
                                                        selectedLabel)),
                                                margin: 8,
                                                reservedSize: 30,
                                              ),
                                              rightTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: false,
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            barGroups: [
                                              BarChartGroupData(
                                                x: 0,
                                                barRods: [
                                                  BarChartRodData(
                                                    colors: gradientColor,
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        0,
                                                        methodTitle),
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 1,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        1,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 2,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        2,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 3,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        3,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 4,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        4,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 5,
                                                barRods: [
                                                  BarChartRodData(
                                                    y: _calculateReportsCount(
                                                        selectedLabel,
                                                        5,
                                                        methodTitle),
                                                    colors: gradientColor,
                                                    width: 22,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 30,
                                    left: screenSize.width * 0.05,
                                    right: screenSize.width * 0.05,
                                  ),
                                  child: Text(
                                    'Available Reports',
                                    style: tertiaryText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                    left: screenSize.width * 0.05,
                                    right: screenSize.width * 0.05,
                                    bottom: 50,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * .05,
                                    vertical: 10,
                                  ),
                                  height: 160,
                                  width: screenSize.width,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: customColor[110],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: customColor[120],
                                            ),
                                          ),
                                          CircularPercentIndicator(
                                            radius: 135,
                                            lineWidth: 6,
                                            percent: _calculateReportCount(
                                                    'Latest') /
                                                _calculteOverallReportCount(
                                                    'Latest'),
                                            center: CircularPercentIndicator(
                                              radius: 110,
                                              lineWidth: 6,
                                              percent: _calculateReportCount(
                                                      'Dropped') /
                                                  _calculteOverallReportCount(
                                                      'Dropped'),
                                              animationDuration: 1200,
                                              center: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: customColor[120],
                                                ),
                                                child: Image.asset(
                                                  'assets/images/no-mask.png',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Color(0xffe4e8f2),
                                              progressColor: customColor[150],
                                            ),
                                            backgroundColor: Color(0xffe4e8f2),
                                            progressColor: customColor[130],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 140,
                                        width: screenSize.width * .4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print("Load Reports");
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        ReportsScreen(
                                                      auth: widget.auth,
                                                      onSignOut:
                                                          widget.onSignOut,
                                                      userUID: widget.userUID,
                                                      tanodId: widget.tanodId,
                                                      email: widget.email,
                                                      name: widget.name,
                                                      profileImage:
                                                          widget.profileImage,
                                                      defaultIndex: 0,
                                                      role: widget.role,
                                                    ),
                                                  ),
                                                );
                                                Reset.filter();
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                padding:
                                                    EdgeInsets.only(left: 2),
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: customColor[120],
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.chevronRight,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            MyReportAvailabilityTile(
                                              color: Color(0xff1c52dd),
                                              title: 'Latest Detection',
                                              count: _calculateReportCount(
                                                  "Latest"),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            MyReportAvailabilityTile(
                                              color: Color(0xff6400e3),
                                              title: 'Dropped Reports',
                                              count: _calculateReportCount(
                                                  "Dropped"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                });
          }),
    );
  }
}
