import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class TaggedScreen extends StatefulWidget {
  const TaggedScreen();

  @override
  _TaggedScreenState createState() => _TaggedScreenState();
}

class _TaggedScreenState extends State<TaggedScreen> {
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
          return ListView(
              shrinkWrap: true,
              dragStartBehavior: DragStartBehavior.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    for (var item in reports)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => DetailReportScreen(
                                id: item['Id'].toString(),
                                image: item['Image'],
                                location: item['Location'],
                                status: item['Status'],
                                date: item['Date'],
                              ),
                            ),
                          );
                        },
                        child: MyReportCard(
                          id: item['Id'].toString(),
                          image: item['Image'],
                          location: item['Location'],
                          status: item['Status'],
                          date: item['Date'],
                        ),
                      ),
                  ],
                )
              ]);
        });
  }
}
