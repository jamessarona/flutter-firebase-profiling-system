import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myListTile.dart';
import 'package:tanood/shared/mySpinKits.dart';

class DetailViolatorScreen extends StatefulWidget {
  final String id;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const DetailViolatorScreen({
    required this.id,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _DetailViolatorScreenState createState() => _DetailViolatorScreenState();
}

class _DetailViolatorScreenState extends State<DetailViolatorScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var violatorData;
  var filteredReportByViolator;
  var locations;

  late Size screenSize;
  int calculateTotalTagged() {
    if (filteredReportByViolator.isNotEmpty) {
      return filteredReportByViolator[0].length;
    }
    return 0;
  }

  String getApprehensionInfo(
      String documentField, int reportId, String violatorId) {
    String value = '';
    for (int i = 0; i < reports[reportId]['AssignedTanod'].length; i++) {
      if (reports[reportId]['AssignedTanod'][i]['Documentation'] != null) {
        for (int x = 0;
            x < reports[reportId]['AssignedTanod'][i]['Documentation'].length;
            x++) {
          value = reports[reportId]['AssignedTanod'][i]['Documentation'][x]
              [documentField];
        }
      }
    }
    return value;
  }

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
                    filteredReportByViolator =
                        filterReportByViolator(reports, widget.id);
                    return StreamBuilder(
                        stream: dbRef.child('Locations').onValue,
                        builder: (context, locationsSnapshot) {
                          if (locationsSnapshot.hasData &&
                              !locationsSnapshot.hasError &&
                              (locationsSnapshot.data! as Event)
                                      .snapshot
                                      .value !=
                                  null) {
                            locations = (locationsSnapshot.data! as Event)
                                .snapshot
                                .value;
                          } else {
                            return MySpinKitLoadingScreen();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Name: ${violatorData['Name']}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Birthday: ${setDateTime(violatorData['Birthday'], 'Date')}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Contact: ${violatorData['Contact']}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                  ),
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
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Gender: ${violatorData['Gender']}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Age: ${calculateAge(violatorData['Birthday'])}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "Tagged: ${calculateTotalTagged()}",
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                  ),
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
                                            fontSize: 15,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                filteredReportByViolator.isNotEmpty
                                    ? Expanded(
                                        child: Container(
                                          child: ListView(
                                            children: [
                                              for (var item
                                                  in filteredReportByViolator[
                                                      0])
                                                MyDocumentationListTile(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            DetailReportScreen(
                                                          id: item['Id']
                                                              .toString(),
                                                          isFromNotification:
                                                              false,
                                                          auth: widget.auth,
                                                          onSignOut:
                                                              widget.onSignOut,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  location: getLocationName(
                                                      locations,
                                                      item['LocationId']),
                                                  date: getApprehensionInfo(
                                                      'DateApprehended',
                                                      int.parse(item['Id']),
                                                      widget.id),
                                                  fine: getApprehensionInfo(
                                                      'Fine',
                                                      int.parse(item['Id']),
                                                      widget.id),
                                                  isTagged: item['Category'] ==
                                                      'Tagged',
                                                ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        });
                  });
            }),
      ),
    );
  }
}
