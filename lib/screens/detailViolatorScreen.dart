import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myListTile.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class DetailViolatorScreen extends StatefulWidget {
  final String id;
  const DetailViolatorScreen({required this.id});

  @override
  _DetailViolatorScreenState createState() => _DetailViolatorScreenState();
}

class _DetailViolatorScreenState extends State<DetailViolatorScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var violatorData;
  var filteredReportByViolator;

  String _getReportId(
    String violatorId,
  ) {
    return '20';
  }

  @override
  Widget build(BuildContext context) {
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
            'Violator Record',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder(
            stream: dbRef.child('Violators').child(widget.id).onValue,
            builder: (context, violatorSnapshot) {
              if (violatorSnapshot.hasData &&
                  !violatorSnapshot.hasError &&
                  (violatorSnapshot.data! as Event).snapshot.value != null) {
                violatorData = (violatorSnapshot.data! as Event).snapshot.value;
              } else {
                return Container(
                  height: 200,
                  width: screenSize.width,
                  child: MySpinKitLoadingScreen(),
                );
              }
              return StreamBuilder(
                  stream: dbRef.child('Reports').onValue,
                  builder: (context, reportsSnapshot) {
                    if (reportsSnapshot.hasData &&
                        !reportsSnapshot.hasError &&
                        (reportsSnapshot.data! as Event).snapshot.value !=
                            null) {
                      reports = (reportsSnapshot.data! as Event).snapshot.value;
                    } else {
                      return Container(
                        height: 200,
                        width: screenSize.width,
                        child: MySpinKitLoadingScreen(),
                      );
                    }
                    return Container(
                      height: screenSize.height,
                      width: screenSize.width,
                      child: Column(
                        children: [
                          Container(
                            width: screenSize.width,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: screenSize.width / 20),
                                      width: screenSize.width * .43,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: ${violatorData['Name']}",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 2,
                                          ),
                                          Text(
                                            "Birthday: ${violatorData['Birthday']}",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "Contact: ${violatorData['Contact']}",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * .43,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Gender: ${violatorData['Gender']}",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "Age: ${calculateAge(violatorData['Birthday'])}",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "Tagged: 3",
                                            style: tertiaryText.copyWith(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: screenSize.width * .045),
                                  child: Text(
                                    "Address: ${violatorData['Address']}",
                                    style: tertiaryText.copyWith(
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ListView(
                                children: [
                                  MyDocumentationListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailReportScreen(
                                            id: _getReportId('3'.toString()),
                                          ),
                                        ),
                                      );
                                    },
                                    location: 'Shopstrat.ph',
                                    date: 'Jan 26, 2022',
                                    fine: '1000.00',
                                  ),
                                  MyDocumentationListTile(
                                    onTap: () {},
                                    location: 'Shopstrat.ph',
                                    date: 'Feb 1, 2022',
                                    fine: '500.00',
                                  ),
                                  MyDocumentationListTile(
                                    onTap: () {},
                                    location: 'Shopstrat.ph',
                                    date: 'Feb 1, 2022',
                                    fine: '300.00',
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
