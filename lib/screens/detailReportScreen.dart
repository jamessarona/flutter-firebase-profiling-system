import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/screens/detailImageFullscreen.dart';
import 'package:tanod_apprehension/shared/constants.dart';
import 'package:tanod_apprehension/shared/myAppbar.dart';
import 'package:tanod_apprehension/shared/myContainers.dart';
import 'package:tanod_apprehension/shared/myText.dart';

class DetailReportScreen extends StatefulWidget {
  final String id;
  final String image;
  final String location;
  final String date;
  final String status;
  const DetailReportScreen({
    required this.id,
    required this.image,
    required this.location,
    required this.date,
    required this.status,
  });

  @override
  _DetailReportScreenState createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  late Size screenSize;
  GlobalKey<ScaffoldState> _scaffoldKeyDetailReports =
      GlobalKey<ScaffoldState>();
  late DateTime dateTime;

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
            actions: [
              MyAppBarAction(
                notifCount: 1,
                color: Colors.white,
                onPressed: () {},
              )
            ],
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
                  bottom: -10,
                  right: -5,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.expand),
                    color: Colors.white,
                    iconSize: 20,
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
                      fontSize: 20,
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
                    color: Colors.green,
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
                  fontSize: 19,
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
                  fontSize: 19,
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
                  fontSize: 19,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
