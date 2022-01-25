import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen();

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
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
            return Container(
              height: 200,
              width: screenSize.width,
              child: MySpinKitLoadingScreen(),
            );
          }
          var filteredReports = filterReport("Latest", reports);
          return filteredReports.isNotEmpty
              ? Container(
                  height: screenSize.height * .75,
                  child: ListView(
                      shrinkWrap: true,
                      dragStartBehavior: DragStartBehavior.start,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: filteredReports[0].length > 1 &&
                                  filteredReports[0].length.isEven
                              ? WrapAlignment.spaceEvenly
                              : WrapAlignment.start,
                          children: [
                            for (var item
                                in filteredReports[0].reversed.toList())
                              Container(
                                margin: EdgeInsets.only(left: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => DetailReportScreen(
                                          id: item['Id'].toString(),
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
                                    color: Colors.green,
                                    isAssigned: checkReportIsAssignedToTanod(
                                        item['Id'].toString()),
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
                );
        });
  }
}
