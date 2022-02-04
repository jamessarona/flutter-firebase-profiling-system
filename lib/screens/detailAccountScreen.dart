import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class DetailAccountScreen extends StatefulWidget {
  final String userUID;
  final String method;
  final bool isEditable;
  const DetailAccountScreen({
    required this.userUID,
    required this.method,
    required this.isEditable,
  });

  @override
  _DetailAccountScreenState createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var tanods;
  var userData;
  bool isLoading = false;
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
              isLoading ? print('Please wait') : Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            'Edit ${widget.method}',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
          actions: [],
        ),
        body: StreamBuilder(
          stream: dbRef.child('Tanods').onValue,
          builder: (context, tanodSnapshot) {
            if (tanodSnapshot.hasData &&
                !tanodSnapshot.hasError &&
                (tanodSnapshot.data! as Event).snapshot.value != null) {
              tanods = (tanodSnapshot.data! as Event).snapshot.value;
            } else {
              return MySpinKitLoadingScreen();
            }
            userData = filterCurrentUserInformation(tanods, widget.userUID)[0];
            return Container(
              height: screenSize.height,
              width: screenSize.width,
            );
          },
        ),
      ),
    );
  }
}
