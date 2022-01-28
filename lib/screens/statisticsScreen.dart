import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/notificationScreen.dart';
import 'package:tanod_apprehension/screens/reportsScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/globals.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myBottomSheet.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';
import 'package:tanod_apprehension/shared/myListTile.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myText.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;

  final String name;
  final String email;
  final String profileImage;
  const StatisticsScreen({
    required this.auth,
    required this.onSignOut,
    required this.name,
    required this.email,
    required this.profileImage,
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
  int notifCount = 0;
  var formatter = NumberFormat('#,##,#00');
  final dbRef = FirebaseDatabase.instance.reference();
  String selectedFilter = "Filter Result";
  String selectedLabel = '';
  String chartTitle = '';
  String methodTitle = '';

  List<Color> gradientColor = [
    Color(0xffadb1ea),
    Color(0xff1c52dd),
  ];
  int _calculateTotalViolatorsCount() {
    num violatorCount = 0;
    if (latestReports.isNotEmpty) {
      for (int i = 0; i < latestReports[0].length; i++) {
        violatorCount += latestReports[0][i]['ViolatorCount'];
      }
    }
    if (droppedReports.isNotEmpty) {
      num tempCount = 0;
      for (int i = 0; i < droppedReports[0].length; i++) {
        if (droppedReports[0][i]['AssignedTanod']
                [droppedReports[0][i]['AssignedTanod'].length - 1]['Reason'] ==
            'Duplicate') {
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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
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
            notifCount = countReportsByLocation(reports);

            latestReports = filterReport("Latest", reports);
            droppedReports = filterReport("Dropped", reports);
            taggedReports = filterReport("Tagged", reports);

            return Scaffold(
              key: _scaffoldKeyStatistics,
              drawer: BuildDrawer(
                leading: "Statistics",
                auth: widget.auth,
                onSignOut: widget.onSignOut,
                name: widget.name,
                email: widget.email,
                profileImage: widget.profileImage,
                backgroundImage: "https://wallpaperaccess.com/full/1397098.jpg",
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: MyAppBarLeading(
                  onPressendDrawer: () {
                    _scaffoldKeyStatistics.currentState!.openDrawer();
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
                          builder: (ctx) => NotificationScreen(),
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: customColor[110],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 0), // changes position of shadow
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              size: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width / 80),
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
                                        filters['Category']['Dropped'] ||
                                        filters['Category']['Tagged'] ||
                                        filters['Date']['Start'] ||
                                        filters['Date']['End'] ||
                                        filters['Area']['Tarape\'s Store'] ||
                                        filters['Area']['ShopStrutt.ph'] ||
                                        filters['Area']['Melchor\'s Store']
                                    ? 'Filtered Results'
                                    : selectedFilter,
                                style: tertiaryText.copyWith(
                                    fontSize: 15, color: Colors.grey[800]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.slidersH,
                              size: 20,
                              color: filters['Category']['Latest'] ||
                                      filters['Category']['Dropped'] ||
                                      filters['Category']['Tagged'] ||
                                      filters['Date']['Start'] ||
                                      filters['Date']['End'] ||
                                      filters['Area']['Tarape\'s Store'] ||
                                      filters['Area']['ShopStrutt.ph'] ||
                                      filters['Area']['Melchor\'s Store']
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
                            style: tertiaryText.copyWith(fontSize: 18),
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
                      child: Text(
                        'Visualization',
                        style: tertiaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyDateLabel(
                            title: 'Day',
                            onTap: () {
                              setState(() {
                                selectedLabel = 'Day';
                                chartTitle = 'Estimated Daily Violators';
                                methodTitle = 'AVG';
                              });
                            },
                            selectedLabel: selectedLabel,
                          ),
                          MyDateLabel(
                            title: 'Week',
                            onTap: () {
                              setState(() {
                                selectedLabel = 'Week';
                                chartTitle = 'Estimated Weekly Violators';
                                methodTitle = 'AVG';
                              });
                            },
                            selectedLabel: selectedLabel,
                          ),
                          MyDateLabel(
                            title: 'Month',
                            onTap: () {
                              setState(() {
                                selectedLabel = 'Month';
                                chartTitle = 'Estimated Monthly Violators';
                                methodTitle = 'AVG';
                              });
                            },
                            selectedLabel: selectedLabel,
                          ),
                          MyDateLabel(
                            title: 'Year',
                            onTap: () {
                              setState(() {
                                selectedLabel = 'Year';
                                chartTitle = 'Estimated Yearly Violators';
                                methodTitle = 'AVG';
                              });
                            },
                            selectedLabel: selectedLabel,
                          ),
                        ],
                      ),
                    ),
                    selectedLabel != ''
                        ? Container(
                            margin: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              chartTitle,
                              style: tertiaryText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    selectedLabel != ''
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                if (methodTitle == 'AVG') {
                                  methodTitle = 'TTL';
                                } else {
                                  methodTitle = 'AVG';
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                left: screenSize.width * 0.4,
                                right: screenSize.width * 0.4,
                              ),
                              alignment: Alignment.center,
                              width: 60,
                              height: 25,
                              decoration: methodTitle != ''
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: customColor[110],
                                      boxShadow: [
                                        BoxShadow(
                                          color: customColor[140]!
                                              .withOpacity(0.1),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(),
                              child: Text(
                                methodTitle,
                                style: tertiaryText.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    //NOT YET DONE
                    selectedLabel != ''
                        ? Container(
                            margin: EdgeInsets.only(
                              left: screenSize.width * 0.05,
                              right: screenSize.width * 0.05,
                            ),
                            height: 250,
                            width: screenSize.width,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.all(
                            //     Radius.circular(20),
                            //   ),
                            //   color: customColor[110],
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.grey.withOpacity(0.3),
                            //       spreadRadius: 3,
                            //       blurRadius: 8,
                            //       offset: Offset(0, 0), // changes position of shadow
                            //     ),
                            //   ],
                            // ),
                            child: LineChart(
                              LineChartData(
                                  minX: 0,
                                  maxX: 11,
                                  minY: 0,
                                  maxY: 6,
                                  titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                    rightTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      getTitles: (value) {
                                        switch (value.toInt()) {
                                          case 1:
                                            return '10';
                                          case 3:
                                            return '20';
                                          case 5:
                                            return '30';
                                        }
                                        return '';
                                      },
                                    ),
                                    bottomTitles: SideTitles(
                                        showTitles: true,
                                        // reservedSize: 20,
                                        getTitles: (value) {
                                          // print(start!.weekday);
                                          // print(start!.month);
                                          if (selectedLabel == 'Day') {
                                            switch (value.toInt()) {
                                              case 0:
                                                return 'Mon';
                                              case 2:
                                                return 'Tue';
                                              case 4:
                                                return 'Wed';
                                              case 5:
                                                return 'Thu';
                                              case 7:
                                                return 'Fri';
                                              case 9:
                                                return 'Sat';
                                              case 11:
                                                return 'Sun';
                                            }
                                          } else if (selectedLabel == 'Week') {
                                            switch (value.toInt()) {
                                              case 1:
                                                return 'Week 1';
                                              case 4:
                                                return 'Week 2';
                                              case 7:
                                                return 'Week 3';
                                              case 10:
                                                return 'Week 4';
                                            }
                                          } else if (selectedLabel == 'Month') {
                                            switch (value.toInt()) {
                                              case 1:
                                                return 'JAN';
                                              case 4:
                                                return 'FEB';
                                              case 7:
                                                return 'MAR';
                                              case 10:
                                                return 'APR';
                                            }
                                          } else {
                                            switch (value.toInt()) {
                                              case 1:
                                                return '2022';
                                              case 4:
                                                return '2023';
                                              case 7:
                                                return '2024';
                                              case 10:
                                                return '2025';
                                            }
                                          }

                                          return '';
                                        }),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    drawHorizontalLine: false,
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        FlSpot(0, 0),
                                        FlSpot(2, 3),
                                        FlSpot(4, 1),
                                        FlSpot(5, 4),
                                        FlSpot(7, 5),
                                        FlSpot(9, 4),
                                        FlSpot(11, 1),
                                      ],
                                      colors: gradientColor,
                                      dotData: FlDotData(show: false),
                                      barWidth: 3,
                                      isCurved: true,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: gradientColor
                                            .map((color) =>
                                                color.withOpacity(0.8))
                                            .toList(),
                                      ),
                                    )
                                  ]),
                            ),
                          )
                        : Container(),
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: customColor[110],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: customColor[120],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 135,
                                lineWidth: 6,
                                percent: _calculateReportCount('Latest') /
                                    _calculteOverallReportCount('Latest'),
                                center: CircularPercentIndicator(
                                  radius: 110,
                                  lineWidth: 6,
                                  percent: _calculateReportCount('Dropped') /
                                      _calculteOverallReportCount('Dropped'),
                                  animationDuration: 1200,
                                  center: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: customColor[120],
                                    ),
                                    child: Image.asset(
                                      'assets/images/no-mask.png',
                                      color: Colors.black,
                                    ),
                                  ),
                                  backgroundColor: Color(0xffe4e8f2),
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Load Reports");
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (ctx) => ReportsScreen(
                                          auth: widget.auth,
                                          onSignOut: widget.onSignOut,
                                          email: widget.email,
                                          name: widget.name,
                                          profileImage: widget.profileImage,
                                        ),
                                      ),
                                    );
                                    Reset.filter();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.only(left: 2),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
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
                                  count: _calculateReportCount("Latest"),
                                ),
                                Container(
                                  height: 10,
                                ),
                                MyReportAvailabilityTile(
                                  color: Color(0xff6400e3),
                                  title: 'Dropped Reports',
                                  count: _calculateReportCount("Dropped"),
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
          }),
    );
  }
}
