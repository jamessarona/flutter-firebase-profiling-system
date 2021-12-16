import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/globals.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class DroppedScreen extends StatefulWidget {
  const DroppedScreen();

  @override
  _DroppedScreenState createState() => _DroppedScreenState();
}

class _DroppedScreenState extends State<DroppedScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: dbRef.child('Reports').onValue,
        builder: (context, reportsSnapshot) {
          if (reportsSnapshot.hasData &&
              !reportsSnapshot.hasError &&
              (reportsSnapshot.data! as Event).snapshot.value != null) {
            reports = (reportsSnapshot.data! as Event).snapshot.value;
          } else {
            return MySpinKitLoadingScreen();
          }
          var filteredReports = filterReport("Dropped", reports);
          return filteredReports.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  dragStartBehavior: DragStartBehavior.start,
                  children: [
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: filteredReports[0].length > 1
                            ? WrapAlignment.spaceEvenly
                            : WrapAlignment.start,
                        children: [
                          for (var item in filteredReports[0])
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => DetailReportScreen(
                                      id: item['Id'].toString(),
                                      image: item['Image'],
                                      location: item['Location'],
                                      category: item['Category'],
                                      date: item['Date'],
                                    ),
                                  ),
                                );
                              },
                              child: MyReportCard(
                                id: item['Id'].toString(),
                                image: item['Image'],
                                location: item['Location'],
                                category: item['Category'],
                                date: item['Date'],
                                color: Colors.red,
                              ),
                            ),
                        ],
                      )
                    ])
              : PageResultMessage(
                  height: 100,
                  width: screenSize.width,
                  message: 'No reports',
                );
        });
  }
}
