import 'package:flutter/material.dart';

class DetailReportScreen extends StatefulWidget {
  final String id;
  final String image;
  final String location;
  final String date;
  final String status;
  const DetailReportScreen(
      {required this.id,
      required this.image,
      required this.location,
      required this.date,
      required this.status});

  @override
  _DetailReportScreenState createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'report_${widget.id}',
          child: Container(
            height: 145,
            width: 170,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  widget.image,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
