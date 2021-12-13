import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference().child("Reports");
  final list = <ListTile>[];
  var reports;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, productsSnapshot) {
          if (productsSnapshot.hasData &&
              !productsSnapshot.hasError &&
              (productsSnapshot.data! as Event).snapshot.value != null) {
            reports = (productsSnapshot.data! as Event).snapshot.value;
          } else {
            return MySpinKitFadingCube();
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
