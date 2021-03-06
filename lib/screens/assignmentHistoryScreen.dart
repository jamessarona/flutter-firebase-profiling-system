import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/myContainers.dart';
import 'package:tanood/shared/mySpinKits.dart';

class AssignmentHistoryScreen extends StatefulWidget {
  final String userUID;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const AssignmentHistoryScreen({
    required this.userUID,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _AssignmentHistoryScreenState createState() =>
      _AssignmentHistoryScreenState();
}

class _AssignmentHistoryScreenState extends State<AssignmentHistoryScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var tanods;
  var userData;
  var assignedReports;
  var locations;
  int tempReportId = -1;
  int tempDuplicateCount = 0;
  int tempAssignedTanodNum = -1;

  List filterReportHistory() {
    int len = 0;
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        for (int x = 0; x < reports[i]['AssignedTanod'].length; x++) {
          if (reports[i]['AssignedTanod'][x]['TanodId'] ==
              userData['TanodId']) {
            len++;
          }
        }
      }
    }
    var filterReportHistoryList = new List.filled(len, []);
    int y = 0;
    for (int i = 0; i < reports.length; i++) {
      if (reports[i]['AssignedTanod'] != null) {
        for (int x = 0; x < reports[i]['AssignedTanod'].length; x++) {
          if (reports[i]['AssignedTanod'][x]['TanodId'] ==
              userData['TanodId']) {
            filterReportHistoryList[y++].add(reports[i]);
          }
        }
      }
    }
    return filterReportHistoryList;
  }

  String getDocumentationInfo(String reportId, String tanodId, String info) {
    String value = '';
    int temp = 0;
    int rId = int.parse(reportId);
    if (tempReportId == rId && info == 'DateAssign') {
      tempDuplicateCount++;
    } else if (tempReportId != rId) {
      tempDuplicateCount = 0;
    }

    for (int i = 0; i < reports[rId]['AssignedTanod'].length; i++) {
      if (reports[rId]['AssignedTanod'][i]['TanodId'] == tanodId) {
        if (tempDuplicateCount - temp == 0) {
          if (info != 'CaughtViolator') {
            value = reports[rId]['AssignedTanod'][i][info] != null
                ? reports[rId]['AssignedTanod'][i][info]
                : '';
          } else {
            value = reports[rId]['AssignedTanod'][i]['Documentation'] != null
                ? reports[rId]['AssignedTanod'][i]['Documentation']
                    .length
                    .toString()
                : '0';
          }
        }
        temp++;
        // for(int x =0; x< reports[rId]['AssignedTanod'][i]['Documentation'].length;x++){

        // }
      }
    }
    tempReportId = rId;
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
            'Apprehension History',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: StreamBuilder(
            stream: dbRef.child('Locations').onValue,
            builder: (context, locationsSnapshot) {
              if (locationsSnapshot.hasData &&
                  !locationsSnapshot.hasError &&
                  (locationsSnapshot.data! as Event).snapshot.value != null) {
                locations = (locationsSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              return StreamBuilder(
                  stream: dbRef.child('Reports').onValue,
                  builder: (context, reportSnapshot) {
                    if (reportSnapshot.hasData &&
                        !reportSnapshot.hasError &&
                        (reportSnapshot.data! as Event).snapshot.value !=
                            null) {
                      reports = (reportSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    return StreamBuilder(
                        stream: dbRef.child('Tanods').onValue,
                        builder: (context, tanodsSnapshot) {
                          if (tanodsSnapshot.hasData &&
                              !tanodsSnapshot.hasError &&
                              (tanodsSnapshot.data! as Event).snapshot.value !=
                                  null) {
                            tanods =
                                (tanodsSnapshot.data! as Event).snapshot.value;
                          } else {
                            return MySpinKitLoadingScreen();
                          }
                          userData = filterCurrentUserInformation(
                              tanods, widget.userUID)[0];
                          assignedReports = filterReportHistory();
                          return assignedReports.isNotEmpty
                              ? ListView(
                                  children: [
                                    for (var item
                                        in assignedReports[0].reversed.toList())
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  DetailReportScreen(
                                                id: item['Id'].toString(),
                                                isFromNotification: false,
                                                auth: widget.auth,
                                                onSignOut: widget.onSignOut,
                                              ),
                                            ),
                                          );
                                        },
                                        child: MyApprehenssionHistoryCard(
                                          id: item['Id'].toString(),
                                          image: item['Image'],
                                          location: getLocationName(
                                              locations, item['LocationId']),
                                          date: getDocumentationInfo(
                                            item['Id'].toString(),
                                            userData['TanodId'].toString(),
                                            'DateAssign',
                                          ),
                                          caughtCount: getDocumentationInfo(
                                              item['Id'].toString(),
                                              userData['TanodId'].toString(),
                                              'CaughtViolator'),
                                          status: getDocumentationInfo(
                                              item['Id'].toString(),
                                              userData['TanodId'].toString(),
                                              'Status'),
                                          remarks: getDocumentationInfo(
                                              item['Id'].toString(),
                                              userData['TanodId'].toString(),
                                              'Reason'),
                                        ),
                                      ),
                                  ],
                                )
                              : PageResultMessage(
                                  height: 100,
                                  width: screenSize.width,
                                  message: 'No Activity',
                                );
                        });
                  });
            }),
      ),
    );
  }
}
