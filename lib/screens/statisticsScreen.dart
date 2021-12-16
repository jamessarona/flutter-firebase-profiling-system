import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myBottomSheet.dart';
import 'package:tanod_apprehension/shared/myDrawers.dart';
import 'package:tanod_apprehension/shared/myListTile.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myText.dart';

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
  int notifCount = 0;
  final dbRef = FirebaseDatabase.instance.reference();
  String selectedFilter = "Filter Result";
  String selectedLabel = 'Month';
  List<Color> gradientColor = [
    Color(0xffadb1ea),
    Color(0xff1c52dd),
  ];
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
              },
            ),
          ],
        ),
        body: StreamBuilder(
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
            return Container(
              height: screenSize.height,
              width: screenSize.width,
              color: customColor[110],
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 10,
                        left: screenSize.width * .13,
                        right: screenSize.width * .13),
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
                          builder: (context) => BuildBottomSheet(),
                        );
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
                              selectedFilter,
                              style: tertiaryText.copyWith(
                                  fontSize: 15, color: Colors.grey[800]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.slidersH,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 60,
                    width: screenSize.width,
                    child: Column(
                      children: [
                        Text(
                          'Caught Violators',
                          style: tertiaryText.copyWith(fontSize: 18),
                        ),
                        Text(
                          '159',
                          style: tertiaryText.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
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
                            });
                          },
                          selectedLabel: selectedLabel,
                        ),
                        MyDateLabel(
                          title: 'Week',
                          onTap: () {
                            setState(() {
                              selectedLabel = 'Week';
                            });
                          },
                          selectedLabel: selectedLabel,
                        ),
                        MyDateLabel(
                          title: 'Month',
                          onTap: () {
                            setState(() {
                              selectedLabel = 'Month';
                            });
                          },
                          selectedLabel: selectedLabel,
                        ),
                        MyDateLabel(
                          title: 'Year',
                          onTap: () {
                            setState(() {
                              selectedLabel = 'Year';
                            });
                          },
                          selectedLabel: selectedLabel,
                        ),
                      ],
                    ),
                  ),
                  //NOT YET DONE
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      left: screenSize.width * 0.05,
                      right: screenSize.width * 0.05,
                    ),
                    padding: EdgeInsets.all(10),
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
                                  switch (value.toInt()) {
                                    case 0:
                                      return 'MAR';
                                    case 5:
                                      return 'APR';
                                    case 11:
                                      return 'MAY';
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
                                FlSpot(0, 3),
                                FlSpot(2.6, 2),
                                FlSpot(4.9, 5),
                                FlSpot(6.8, 2),
                                FlSpot(9.4, 1),
                                FlSpot(11, 6),
                              ],
                              colors: gradientColor,
                              dotData: FlDotData(show: false),
                              barWidth: 3,
                              isCurved: true,
                              belowBarData: BarAreaData(
                                show: true,
                                colors: gradientColor
                                    .map((color) => color.withOpacity(0.8))
                                    .toList(),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
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
                        top: 15,
                        left: screenSize.width * 0.05,
                        right: screenSize.width * 0.05,
                        bottom: 50),
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
                              percent: 0.4,
                              center: CircularPercentIndicator(
                                radius: 110,
                                lineWidth: 6,
                                percent: 0.8,
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
                                count: 3,
                              ),
                              Container(
                                height: 10,
                              ),
                              MyReportAvailabilityTile(
                                color: Color(0xff6400e3),
                                title: 'Dropped Reports',
                                count: 3,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
