import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myCards.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

final dbRef = FirebaseDatabase.instance.reference();
var reports;
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
            return Container(
              margin: EdgeInsets.only(top: 3),
              child: ListView(
                children: [
                  for (var item in filteredReports[0])
                    Card(
                      child: ListTile(
                        leading: Container(),
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
