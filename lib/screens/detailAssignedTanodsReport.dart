import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';

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
        body: Container(),
      ),
    );
  }
}
