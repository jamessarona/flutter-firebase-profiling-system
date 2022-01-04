import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/detailAssignedTanodsReport.dart';
import 'package:tanod_apprehension/screens/detailImageFullscreen.dart';
import 'package:tanod_apprehension/screens/documentReportScreen.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/mySpinKits.dart';
import 'package:tanod_apprehension/shared/myText.dart';

class DetailReportScreen extends StatefulWidget {
  final String id;
  const DetailReportScreen({
    required this.id,
  });

  @override
  _DetailReportScreenState createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  late Size screenSize;
  GlobalKey<ScaffoldState> _scaffoldKeyDetailReports =
      GlobalKey<ScaffoldState>();
  late DateTime dateTime;
  final dbRef = FirebaseDatabase.instance.reference();
  bool isAssigned = false;
  bool isAssignedToUser = false;
  bool isUserHasActiveReport = false;
  bool isTaggedReport = false;
  bool isLoading = false;
  late Timer _timer;
  var tanods;
  var userData;
  var reports;
  var selectedReport;
  String userUID = '';

  _buildCreateAssignConfirmaModal(BuildContext context, String title) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                'Confirmation',
                style: tertiaryText.copyWith(fontSize: 18),
              ),
              content: Text.rich(
                TextSpan(
                  style: tertiaryText.copyWith(fontSize: 16),
                  children: [
                    TextSpan(
                        text: title == 'Assign'
                            ? 'Do you want to apprehend the violator in '
                            : 'Do you want to '),
                    title == 'Assign'
                        ? TextSpan(
                            text: selectedReport[0]['Location'],
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          )
                        : TextSpan(
                            text: 'Drop',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          ),
                    title == 'Assign'
                        ? TextSpan(
                            text: '',
                          )
                        : TextSpan(
                            text: ' the report?',
                          ),
                  ],
                ),
              ),
              actions: [
                Container(
                  width: 100,
                  child: MyOutlineButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Cancel',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: customColor[140]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: MyRaisedButton(
                    color: Color(0xff1640ac),
                    elavation: 5,
                    isLoading: isLoading,
                    radius: 10,
                    text: Text(
                      'Confirm',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      if (title == 'Assign') {
                        if (checkAssignableReport() == true) {
                          _saveAssignReportToTanod().then((value) {
                            isAssigned = true;
                            Navigator.pop(context);
                            _buildModalSuccessMessage(context, title);
                            isLoading = false;
                          });
                        } else {
                          Navigator.pop(context);
                          _buildModalFailedMessage(context);
                          isLoading = false;
                        }
                      } else {
                        _dropAssignReportToTanod().then((value) {
                          Navigator.pop(context);
                          isAssigned = false;
                          _buildModalSuccessMessage(context, title);
                          isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  bool checkAssignableReport() {
    bool result = false;
    if (selectedReport[0]['AssignedTanod'] != null) {
      print(selectedReport[0]['AssignedTanod']
          [selectedReport[0]['AssignedTanod'].length - 1]['Status']);
      if (selectedReport[0]['AssignedTanod']
              [selectedReport[0]['AssignedTanod'].length - 1]['Status'] ==
          'Dropped') {
        result = true;
      }
    } else {
      result = true;
    }
    return result;
  }

  Future<String> _saveAssignReportToTanod() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    await dbRef.child('Tanods').child(userUID).update({
      'Status': 'Responding',
    });
    if (selectedReport[0]['AssignedTanod'] != null) {
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .child('AssignedTanod')
          .update({
        (selectedReport[0]['AssignedTanod'].length).toString(): {
          'DateAssign': dateFormat.format(DateTime.now()).toString(),
          'Status': 'Responding',
          'TanodId': userData['ID'],
        },
      });
    } else {
      await dbRef
          .child('Reports')
          .child(selectedReport[0]['Id'].toString())
          .update({
        'AssignedTanod': {
          '0': {
            'DateAssign': dateFormat.format(DateTime.now()).toString(),
            'Status': 'Responding',
            'TanodId': userData['ID'],
          }
        },
      });
    }

    return '';
  }

  Future<String> _dropAssignReportToTanod() async {
    await dbRef.child('Tanods').child(userUID).update({
      'Status': 'Standby',
    });
    await dbRef
        .child('Reports')
        .child(selectedReport[0]['Id'].toString())
        .update({
      'Category': 'Dropped',
    });
    await dbRef
        .child('Reports')
        .child(selectedReport[0]['Id'].toString())
        .child('AssignedTanod')
        .child((selectedReport[0]['AssignedTanod'].length - 1).toString())
        .update({
      'DateAssign': selectedReport[0]['AssignedTanod']
          [selectedReport[0]['AssignedTanod'].length - 1]['DateAssign'],
      'Status': 'Dropped',
      'TanodId': selectedReport[0]['AssignedTanod']
          [selectedReport[0]['AssignedTanod'].length - 1]['TanodId'],
    });

    return '';
  }

  Future<void> _buildModalSuccessMessage(
      BuildContext context, String title) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: title == 'Assign' ? customColor[130] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: Container(
            height: 80,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title == 'Assign'
                        ? 'Report Assigned Successfully'
                        : 'Report Dropped Successfully',
                    style: tertiaryText.copyWith(
                      fontSize: 25,
                      color: title == 'Assign' ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  Future<void> _buildModalFailedMessage(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: Container(
            height: 80,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'This report is already assigned to other Tanod',
                    style: tertiaryText.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  void validateActions() {
    if (selectedReport[0]['AssignedTanod'] != null) {
      if (selectedReport[0]['AssignedTanod']
                  [selectedReport[0]['AssignedTanod'].length - 1]['Status']
              .compareTo('Responding') ==
          0) {
        isAssigned = true;
        if (selectedReport[0]['AssignedTanod']
                [selectedReport[0]['AssignedTanod'].length - 1]['TanodId'] ==
            userData['ID']) {
          isAssignedToUser = true;
        }
      }
    }
  }

  void checkUserHasActiveReport() {
    isUserHasActiveReport = false;
    if (userData['Status'] == 'Responding') {
      isUserHasActiveReport = true;
    }
  }

  void checkReportIsTagged() {
    isTaggedReport = false;
    if (selectedReport[0]['Category'] == 'Tagged') {
      isTaggedReport = true;
    }
  }

  String setAssignTanodName() {
    return selectedReport[0]['AssignedTanod']
        [selectedReport[0]['AssignedTanod'].length - 1]['TanodId'];
  }

  String setDateTime(String method) {
    late DateTime dateTimeAssigned = DateTime.parse(selectedReport[0]
            ['AssignedTanod'][selectedReport[0]['AssignedTanod'].length - 1]
        ['DateAssign']);

    if (method == 'Date') {
      return "${convertMonth(dateTimeAssigned.month)} ${dateTimeAssigned.day}, ${dateTimeAssigned.year}";
    } else {
      return "${convertHour(dateTimeAssigned.hour, 0)}:${dateTimeAssigned.minute}:${dateTimeAssigned.second} ${convertHour(dateTimeAssigned.hour, 1)}";
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      getCurrentUserUID().then((valueID) {
        setState(() {
          userUID = valueID;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return userUID.isNotEmpty
        ? SafeArea(
            child: StreamBuilder(
              stream: dbRef.child('Tanods').onValue,
              builder: (context, tanodSnapshot) {
                if (tanodSnapshot.hasData &&
                    !tanodSnapshot.hasError &&
                    (tanodSnapshot.data! as Event).snapshot.value != null) {
                  tanods = (tanodSnapshot.data! as Event).snapshot.value;
                } else {
                  return Scaffold(body: MySpinKitLoadingScreen());
                }
                return StreamBuilder(
                    stream: dbRef.child('Tanods').child(userUID).onValue,
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasData &&
                          !userSnapshot.hasError &&
                          (userSnapshot.data! as Event).snapshot.value !=
                              null) {
                        userData = (userSnapshot.data! as Event).snapshot.value;
                      } else {
                        return Scaffold(body: MySpinKitLoadingScreen());
                      }
                      return StreamBuilder(
                          stream: dbRef.child('Reports').onValue,
                          builder: (context, reportSnapshot) {
                            if (reportSnapshot.hasData &&
                                !reportSnapshot.hasError &&
                                (reportSnapshot.data! as Event)
                                        .snapshot
                                        .value !=
                                    null) {
                              reports = (reportSnapshot.data! as Event)
                                  .snapshot
                                  .value;
                            } else {
                              return Scaffold(body: MySpinKitLoadingScreen());
                            }
                            selectedReport = getSelectedReportInformation(
                                reports, widget.id);
                            dateTime =
                                DateTime.parse(selectedReport[0]['Date']);
                            validateActions();
                            checkUserHasActiveReport();
                            checkReportIsTagged();
                            return Scaffold(
                              backgroundColor: customColor[110],
                              key: _scaffoldKeyDetailReports,
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(200),
                                child: AppBar(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  leading: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  flexibleSpace: Stack(
                                    children: [
                                      ClipRRect(
                                        child: Hero(
                                          tag: 'report_${widget.id}',
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    selectedReport[0]['Image']),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -5,
                                        right: -3,
                                        child: IconButton(
                                          icon: Icon(FontAwesomeIcons.expand),
                                          color: Colors.white,
                                          iconSize: 18,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    ImageFullScreen(
                                                  tag: widget.id,
                                                  image: selectedReport[0]
                                                      ['Image'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              body: ListView(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.only(top: 15),
                                    width: screenSize.width,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.only(
                                    //       topLeft: Radius.circular(20),
                                    //       topRight: Radius.circular(20)),
                                    //   color: customColor[130],
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //       color: Colors.grey.withOpacity(0.3),
                                    //       spreadRadius: 3,
                                    //       blurRadius: 8,
                                    //       offset: Offset(0, 0), // changes position of shadow
                                    //     ),
                                    //   ],
                                    // ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Details',
                                          style: secandaryText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Container(
                                          width: 5,
                                        ),
                                        MyReportStatusIndicator(
                                          height: 10,
                                          width: 10,
                                          color: 'Pending' == 'Responding'
                                              ? Color(0xffdd901c)
                                              : selectedReport[0]['Category'] ==
                                                      'Latest'
                                                  ? Colors.green
                                                  : Colors.red,
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.5,
                                  ),
                                  MyReportDetails(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width: screenSize.width,
                                    label: Text(
                                      'Area: ${selectedReport[0]['Location']}',
                                      style: tertiaryText.copyWith(
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  MyReportDetails(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width: screenSize.width,
                                    label: Text(
                                      'Date: ${convertMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}',
                                      style: tertiaryText.copyWith(
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  MyReportDetails(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width: screenSize.width,
                                    label: Text(
                                      'Time: ${convertHour(dateTime.hour, 0)}:${dateTime.minute}:${dateTime.second} ${convertHour(dateTime.hour, 1)}',
                                      style: tertiaryText.copyWith(
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Divider(
                                      thickness: 5,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  isAssigned ||
                                          selectedReport[0]['Category'] !=
                                              'Latest'
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          width: screenSize.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            'Apprehension Summary'),
                                                    (selectedReport[0][
                                                                'AssignedTanod'] !=
                                                            null
                                                        ? TextSpan(
                                                            text:
                                                                ' - Recent Actions',
                                                            style: tertiaryText
                                                                .copyWith(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          )
                                                        : TextSpan()),
                                                  ],
                                                ),
                                              ),
                                              MyReportDetails(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                ),
                                                width: screenSize.width,
                                                label: Text(
                                                  'Tanod: ${setAssignTanodName()}',
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              MyReportDetails(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                ),
                                                width: screenSize.width,
                                                label: Text(
                                                  "Date: ${setDateTime('Date')}",
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              MyReportDetails(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                ),
                                                width: screenSize.width,
                                                label: Text(
                                                  "Time: ${setDateTime('Time')}",
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              MyReportDetails(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                ),
                                                width: screenSize.width,
                                                label: Text(
                                                  'Number of Violator: 1',
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              MyReportDetails(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                width: screenSize.width,
                                                label: Text(
                                                  'Status: ${selectedReport[0]['AssignedTanod'][selectedReport[0]['AssignedTanod'].length - 1]['Status']}',
                                                  style: tertiaryText.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print('Load Report Activity');
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          DetailAssignedTanodsReport(
                                                              id: widget.id),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        style: tertiaryText
                                                            .copyWith(
                                                          fontSize: 15,
                                                          color:
                                                              customColor[130],
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  'See More '),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .angleDoubleRight,
                                                              size: 18,
                                                              color:
                                                                  customColor[
                                                                      130],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 250,
                                          alignment: Alignment.center,
                                          width: screenSize.width,
                                          child: Text(
                                            'No Apprehension Yet',
                                            style: tertiaryText.copyWith(
                                              fontSize: 20,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                ],
                              ),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerDocked,
                              floatingActionButton: Container(
                                width: screenSize.width,
                                height: 100,
                                child: isAssigned
                                    ? isAssignedToUser
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: screenSize.width * .46,
                                                  height: 50,
                                                  child: MyOutlineButton(
                                                    elavation: 0,
                                                    color: Color(0xff1c52dd),
                                                    radius: 10,
                                                    onPressed: () {
                                                      _buildCreateAssignConfirmaModal(
                                                              context, 'Drop')
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    isLoading: false,
                                                    text: Text(
                                                      'Drop Report',
                                                      style:
                                                          tertiaryText.copyWith(
                                                        fontSize: 18,
                                                        letterSpacing: 0,
                                                        color:
                                                            Color(0xff1c52dd),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                height: 50,
                                                width: screenSize.width * .46,
                                                child: MyFloatingButton(
                                                  onPressed: () {
                                                    print(
                                                        'Load Report Documentation');
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            ReportDocumentation(
                                                                id: widget.id),
                                                      ),
                                                    );
                                                  },
                                                  title: Text(
                                                    'Document Report',
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 18,
                                                      letterSpacing: 0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  radius: 10,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container()
                                    : isUserHasActiveReport || isTaggedReport
                                        ? Container()
                                        : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: screenSize.width / 7.5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  'Immediately respond to the screne',
                                                  style: tertiaryText.copyWith(
                                                    color: Colors.grey[700],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                width: screenSize.width * .8,
                                                height: 50,
                                                child: MyFloatingButton(
                                                  onPressed: () {
                                                    _buildCreateAssignConfirmaModal(
                                                            context, 'Assign')
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                  title: Text(
                                                    'Apprehend',
                                                    style:
                                                        tertiaryText.copyWith(
                                                      fontSize: 20,
                                                      letterSpacing: 2,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  radius: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                              ),
                            );
                          });
                    });
              },
            ),
          )
        : Scaffold(body: MySpinKitLoadingScreen());
  }
}
