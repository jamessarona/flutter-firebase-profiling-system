import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/screens/detailReportScreen.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/myCards.dart';
import 'package:tanood/shared/myContainers.dart';
import 'package:tanood/shared/mySpinKits.dart';

class NotificationScreen extends StatefulWidget {
  final String tanodId;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const NotificationScreen({
    required this.tanodId,
    required this.auth,
    required this.onSignOut,
  });

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

final dbRef = FirebaseDatabase.instance.reference();
var reports;
var locations;
var userData;
late Size screenSize;

class _NotificationScreenState extends State<NotificationScreen> {
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
            'Notifications',
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
              stream: dbRef.child('Tanods').child(widget.tanodId).onValue,
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.hasData &&
                    !userDataSnapshot.hasError &&
                    (userDataSnapshot.data! as Event).snapshot.value != null) {
                  userData = (userDataSnapshot.data! as Event).snapshot.value;
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
                      reports = (reportsSnapshot.data! as Event).snapshot.value;
                    } else {
                      return Container(
                        height: 200,
                        width: screenSize.width,
                        child: MySpinKitLoadingScreen(),
                      );
                    }

                    var filteredReports;
                    var filterPreferenceReports;
                    if (reports.length > 0) {
                      filteredReports = filterReport("Latest", reports);
                      if (filteredReports.length > 0) {
                        filterPreferenceReports = filterPreferenceReport(
                            filteredReports[0], userData['LocationId']);
                      }
                    }
                    return filteredReports.isNotEmpty &&
                            filterPreferenceReports.isNotEmpty
                        ? Container(
                            height: screenSize.height,
                            width: screenSize.width,
                            child: ListView(
                              shrinkWrap: true,
                              dragStartBehavior: DragStartBehavior.start,
                              children: [
                                for (var item in filterPreferenceReports[0]
                                    .reversed
                                    .toList())
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DetailReportScreen(
                                            id: item['Id'].toString(),
                                            isFromNotification: false,
                                            auth: widget.auth,
                                            onSignOut: widget.onSignOut,
                                          ),
                                        ),
                                      );
                                    },
                                    child: MyNotificationReportCard(
                                      id: item['Id'].toString(),
                                      image: item['Image'],
                                      violators: item['ViolatorCount'],
                                      location: getLocationName(
                                          locations, item['LocationId']),
                                      category: item['Category'],
                                      date: item['Date'],
                                      color: Colors.green,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : PageResultMessage(
                            height: 100,
                            width: screenSize.width,
                            message: 'No reports',
                          );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
