import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/globals.dart';
import 'package:tanood/shared/myBottomSheet.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/myContainers.dart';
import 'package:tanood/shared/mySpinKits.dart';

class ActiveScreen extends StatefulWidget {
  final String userUID;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const ActiveScreen({
    required this.userUID,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var filteredReports;
  var tanods;
  var userData;
  var locations;

  bool checkReportIsAssignedToTanod(String reportId, int method) {
    bool status = false;
    for (int i = 0; i < filteredReports[0].length; i++) {
      if (filteredReports[0][i]['AssignedTanod'] != null) {
        if (filteredReports[0][i]['Id'].toString() == reportId) {
          if (method == 1) {
            if (filteredReports[0][i]['AssignedTanod'][
                            filteredReports[0][i]['AssignedTanod'].length -
                                1]['TanodId']
                        .toString() ==
                    userData['TanodId'].toString() &&
                filteredReports[0][i]['AssignedTanod']
                            [filteredReports[0][i]['AssignedTanod'].length - 1]
                        ['Status'] ==
                    'Responding') {
              status = true;
            }
          } else {
            if (filteredReports[0][i]['AssignedTanod']
                        [filteredReports[0][i]['AssignedTanod'].length - 1]
                    ['Status'] ==
                'Responding') {
              status = true;
            }
          }
        }
      }
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: dbRef.child('Tanods').onValue,
        builder: (context, tanodsSnapshot) {
          if (tanodsSnapshot.hasData &&
              !tanodsSnapshot.hasError &&
              (tanodsSnapshot.data! as Event).snapshot.value != null) {
            tanods = (tanodsSnapshot.data! as Event).snapshot.value;
          } else {
            return Container(
              height: 200,
              width: screenSize.width,
              child: MySpinKitLoadingScreen(),
            );
          }
          userData = filterCurrentUserInformation(tanods, widget.userUID)[0];

          return StreamBuilder(
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
                    builder: (context, reportsSnapshot) {
                      if (reportsSnapshot.hasData &&
                          !reportsSnapshot.hasError &&
                          (reportsSnapshot.data! as Event).snapshot.value !=
                              null) {
                        reports =
                            (reportsSnapshot.data! as Event).snapshot.value;
                      } else {
                        return Container(
                          height: 200,
                          width: screenSize.width,
                          child: MySpinKitLoadingScreen(),
                        );
                      }

                      filteredReports = filterReport("Latest", reports);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width / 25),
                            width: screenSize.width,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 30,
                                  width: screenSize.width * .8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // MySortButton(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       sort['Location'] = !sort['Location'];
                                      //     });
                                      //   },
                                      //   title: 'Area',
                                      //   icon: Icon(
                                      //     sort['Location']
                                      //         ? FontAwesomeIcons.sortAlphaDown
                                      //         : FontAwesomeIcons.sortAlphaUp,
                                      //     size: 15,
                                      //     color: Colors.grey[700],
                                      //   ),
                                      // ),
                                      // Container(
                                      //   width: 5,
                                      // ),
                                      // MySortButton(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       sort['Date'] = !sort['Date'];
                                      //     });
                                      //   },
                                      //   title: 'Date',
                                      //   icon: Icon(
                                      //     sort['Date']
                                      //         ? FontAwesomeIcons.sortNumericDown
                                      //         : FontAwesomeIcons.sortNumericUp,
                                      //     size: 15,
                                      //     color: Colors.grey[700],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
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
                                        page: 'Reports',
                                      ),
                                    ).then((value) => setState(() {}));
                                  },
                                  child: Image.asset(
                                    'assets/images/filter-data.png',
                                    width: 17,
                                    height: 17,
                                    fit: BoxFit.cover,
                                    color: filters['Date']['Start'] ||
                                            filters['Date']['End'] ||
                                            filters['Area']
                                                ['Tarape\'s Store'] ||
                                            filters['Area']['ShopStrutt.ph'] ||
                                            filters['Area']['Melchor\'s Store']
                                        ? customColor[170]
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          filteredReports.isNotEmpty
                              ? Container(
                                  height: screenSize.height * .75,
                                  child: ListView(
                                      shrinkWrap: true,
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          alignment:
                                              filteredReports[0].length > 1 &&
                                                      filteredReports[0]
                                                          .length
                                                          .isEven
                                                  ? WrapAlignment.spaceEvenly
                                                  : WrapAlignment.start,
                                          children: [
                                            for (var item in filteredReports[0]
                                                .reversed
                                                .toList())
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 6),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            DetailReportScreen(
                                                          id: item['Id']
                                                              .toString(),
                                                          isFromNotification:
                                                              false,
                                                          onSignOut:
                                                              widget.onSignOut,
                                                          auth: widget.auth,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: MyReportCard(
                                                    id: item['Id'].toString(),
                                                    image: item['Image'],
                                                    violator:
                                                        item['ViolatorCount'],
                                                    location: getLocationName(
                                                        locations,
                                                        item['LocationId']),
                                                    category: item['Category'],
                                                    date: item['Date'],
                                                    color:
                                                        checkReportIsAssignedToTanod(
                                                                item['Id']
                                                                    .toString(),
                                                                2)
                                                            ? Colors.orange
                                                            : Colors.green,
                                                    isAssigned:
                                                        checkReportIsAssignedToTanod(
                                                            item['Id']
                                                                .toString(),
                                                            1),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      ]),
                                )
                              : PageResultMessage(
                                  height: 100,
                                  width: screenSize.width,
                                  message: 'No reports',
                                ),
                        ],
                      );
                    });
              });
        });
  }
}
