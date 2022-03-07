import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanood/shared/constants.dart';
import 'package:tanood/shared/mySpinKits.dart';

class DetailAssignedTanodsReport extends StatefulWidget {
  final String id;
  const DetailAssignedTanodsReport({required this.id});

  @override
  _DetailAssignedTanodsReportState createState() =>
      _DetailAssignedTanodsReportState();
}

class _DetailAssignedTanodsReportState
    extends State<DetailAssignedTanodsReport> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var selectedReport;
  var tanods;

  String _getTanodName(String tanodId) {
    String tanodName = '';
    for (int i = 0; i < tanods.length; i++) {
      if (tanods[i]['TanodId'] == tanodId) {
        tanodName = "${tanods[i]['Firstname']} ${tanods[i]['Lastname']}";
      }
    }
    return tanodName;
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
            icon: Icon(FontAwesomeIcons.chevronLeft),
            color: Colors.black,
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            'Report Activity',
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
              selectedReport = getSelectedReportInformation(reports, widget.id);
              return StreamBuilder(
                  stream: dbRef.child('Tanods').onValue,
                  builder: (context, tanodSnapshot) {
                    if (tanodSnapshot.hasData &&
                        !tanodSnapshot.hasError &&
                        (tanodSnapshot.data! as Event).snapshot.value != null) {
                      tanods = (tanodSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    return ListView(
                      children: [
                        for (var item in selectedReport[0]["AssignedTanod"]
                            .reversed
                            .toList())
                          Card(
                            child: ListTile(
                              title: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Tanod: ${_getTanodName(item['TanodId'])}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Text(
                                        "Date: ${setDateTime(item['DateAssign'], 'Date')}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Text(
                                        "Time: ${setDateTime(item['DateAssign'], 'Time')}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Text(
                                        "Caught Violator: ${item['Documentation'] != null ? item['Documentation'].length : 0}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Text(
                                        "Status: ${item['Status']}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Text(
                                        "Remarks: ${item['Reason'] != null ? item['Reason'] : ''}",
                                        style: tertiaryText.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
