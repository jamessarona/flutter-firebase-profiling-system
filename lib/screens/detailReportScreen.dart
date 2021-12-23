import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/detailImageFullscreen.dart';
import 'package:tanod_apprehension/screens/documentReportScreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myButtons.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/myText.dart';

class DetailReportScreen extends StatefulWidget {
  final String id;
  final String image;
  final String location;
  final String date;
  final String category;
  const DetailReportScreen({
    required this.id,
    required this.image,
    required this.location,
    required this.date,
    required this.category,
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
  var report;
  bool isAssigned = false;
  _buildCreateConfirmaModal(BuildContext context) {
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
                    TextSpan(text: 'Do you want to apprehend the violator in '),
                    TextSpan(
                      text: '${widget.location}',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red,
                      ),
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
                    isLoading: false,
                    radius: 10,
                    text: Text(
                      'Confirm',
                      style: tertiaryText.copyWith(
                          fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      isAssigned = true;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    dateTime = DateTime.parse(widget.date);
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                            widget.image,
                          ),
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
                          builder: (ctx) => ImageFullScreen(
                            tag: widget.id,
                            image: widget.image,
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
              margin: EdgeInsets.symmetric(horizontal: 15),
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
                        : widget.category == 'Latest'
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
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: screenSize.width,
              label: Text(
                'Area: ${widget.location}',
                style: tertiaryText.copyWith(
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            MyReportDetails(
              margin: EdgeInsets.symmetric(horizontal: 15),
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
              margin: EdgeInsets.symmetric(horizontal: 15),
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
            isAssigned
                ? Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    width: screenSize.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apprehension Summary',
                          style: tertiaryText.copyWith(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        MyReportDetails(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                          ),
                          width: screenSize.width,
                          label: Text(
                            'Tanod: James Angelo Sarona',
                            style: tertiaryText.copyWith(
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                            'Date: Dec 6, 2021',
                            style: tertiaryText.copyWith(
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                            'Time: 12:26:35 PM',
                            style: tertiaryText.copyWith(
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                            overflow: TextOverflow.ellipsis,
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
                            'Status: Responding',
                            style: tertiaryText.copyWith(
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: screenSize.width,
          height: 100,
          child: isAssigned
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: screenSize.width * .46,
                        height: 50,
                        child: MyOutlineButton(
                          elavation: 0,
                          color: Color(0xff1c52dd),
                          radius: 10,
                          onPressed: () {
                            setState(() {
                              isAssigned = false;
                            });
                          },
                          isLoading: false,
                          text: Text(
                            'Drop Report',
                            style: tertiaryText.copyWith(
                              fontSize: 18,
                              letterSpacing: 0,
                              color: Color(0xff1c52dd),
                            ),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 50,
                      width: screenSize.width * .46,
                      child: MyFloatingButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ReportDocumentation(),
                            ),
                          );
                        },
                        title: Text(
                          'Document Report',
                          style: tertiaryText.copyWith(
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
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: screenSize.width / 8.5,
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
                          _buildCreateConfirmaModal(context).then((value) {
                            setState(() {});
                          });
                        },
                        title: Text(
                          'Apprehend',
                          style: tertiaryText.copyWith(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                        radius: 10,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
