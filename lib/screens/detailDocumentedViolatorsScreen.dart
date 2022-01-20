import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';

class DetailDocumentedViolatorScreen extends StatefulWidget {
  final String id;
  const DetailDocumentedViolatorScreen({required this.id});

  @override
  _DetailDocumentedViolatorScreenState createState() =>
      _DetailDocumentedViolatorScreenState();
}

class _DetailDocumentedViolatorScreenState
    extends State<DetailDocumentedViolatorScreen> {
  late Size screenSize;
  final dbRef = FirebaseDatabase.instance.reference();
  var reports;
  var selectedReport;
  var tanods;
  var violators;

  int _calculateApprehendedViolatorCount() {
    num count = 0;
    if (selectedReport[0]['AssignedTanod'] != null) {
      for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
        if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
          count +=
              selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
        }
      }
    }
    return count.toInt();
  }

  List filterDocuments() {
    int count = _calculateApprehendedViolatorCount();
    var documents = new List.filled(count, []);
    int y = 0;
    if (selectedReport[0]['AssignedTanod'] != null) {
      for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
        if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
          for (int x = 0;
              x < selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
              x++) {
            documents[y++]
                .add(selectedReport[0]['AssignedTanod'][i]['Documentation'][x]);
          }
        }
      }
    }
    return documents[0];
  }

  String _getApprehenderId(String violatorId) {
    String apprehenderName = '';
    for (int i = 0; i < selectedReport[0]['AssignedTanod'].length; i++) {
      if (selectedReport[0]['AssignedTanod'][i]['Documentation'] != null) {
        for (int x = 0;
            x < selectedReport[0]['AssignedTanod'][i]['Documentation'].length;
            x++) {
          if (selectedReport[0]['AssignedTanod'][i]['Documentation'][x]
                  ['ViolatorId'] ==
              violatorId) {
            apprehenderName = _getApprehenderName(
                selectedReport[0]['AssignedTanod'][i]['TanodId']);
          }
        }
      }
    }
    return apprehenderName;
  }

  String _getApprehenderName(String tanodId) {
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
            'Documented Violators',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
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
              return StreamBuilder(
                  stream: dbRef.child('Reports').onValue,
                  builder: (context, reportSnapshot) {
                    if (reportSnapshot.hasData &&
                        !reportSnapshot.hasError &&
                        (reportSnapshot.data! as Event).snapshot.value !=
                            null) {
                      reports = (reportSnapshot.data! as Event).snapshot.value;
                    } else {
                      return MySpinKitLoadingScreen();
                    }
                    selectedReport =
                        getSelectedReportInformation(reports, widget.id);
                    return StreamBuilder(
                        stream: dbRef.child('Violators').onValue,
                        builder: (context, violatorSnapshot) {
                          if (violatorSnapshot.hasData &&
                              !violatorSnapshot.hasError &&
                              (violatorSnapshot.data! as Event)
                                      .snapshot
                                      .value !=
                                  null) {
                            violators = (violatorSnapshot.data! as Event)
                                .snapshot
                                .value;
                          } else {
                            return MySpinKitLoadingScreen();
                          }
                          return ListView(
                            children: [
                              for (var item
                                  in filterDocuments().reversed.toList())
                                Card(
                                  child: ListTile(
                                    title: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                                "Violator: ${getViolatorSpecifiedInformation(violators, item['ViolatorId'], 'Name')}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                                "Contact: ${getViolatorSpecifiedInformation(violators, item['ViolatorId'], 'Contact')}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                                "Apprehender: ${_getApprehenderId(item['ViolatorId'].toString())}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                                "Date: ${setDateTime(item['DateApprehended'], 'Time')} / ${setDateTime(item['DateApprehended'], 'Date')}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child:
                                                Text("Fine: ₱${item['Fine']}"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        });
                  });
            }),
      ),
    );
  }
}
