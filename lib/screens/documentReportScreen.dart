import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class ReportDocumentation extends StatefulWidget {
  const ReportDocumentation({Key? key}) : super(key: key);

  @override
  _ReportDocumentationState createState() => _ReportDocumentationState();
}

class _ReportDocumentationState extends State<ReportDocumentation> {
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
            'Documentation',
            style: primaryText.copyWith(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: Container(),
      ),
    );
  }
}
