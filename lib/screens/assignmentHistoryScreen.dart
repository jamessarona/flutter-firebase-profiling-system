import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class AssignmentHistoryScreen extends StatefulWidget {
  final String userUID;

  const AssignmentHistoryScreen({required this.userUID});

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
            stream: dbRef.child('Reports').onValue,
            builder: (context, reportSnapshot) {
              if (reportSnapshot.hasData &&
                  !reportSnapshot.hasError &&
                  (reportSnapshot.data! as Event).snapshot.value != null) {
                reports = (reportSnapshot.data! as Event).snapshot.value;
              } else {
                return MySpinKitLoadingScreen();
              }
              return StreamBuilder<Object>(
                  stream: dbRef.child('Tanods').onValue,
                  builder: (context, tanodsSnapshot) {
                    if (tanodsSnapshot.hasData &&
                        !tanodsSnapshot.hasError &&
                        (tanodsSnapshot.data! as Event).snapshot.value !=
                            null) {
                      tanods = (tanodsSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    userData =
                        filterCurrentUserInformation(tanods, widget.userUID);
                    return ListView(
                      children: [
                        Card(),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
