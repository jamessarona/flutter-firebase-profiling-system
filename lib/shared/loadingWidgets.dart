import 'package:flutter/material.dart';
import 'package:tanood/shared/mySpinKits.dart';

class MyLoadingScreenHomeScreen extends StatelessWidget {
  const MyLoadingScreenHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MySpinKitLoadingScreen(),
      ),
    );
  }
}

class MyLoadingScreenReportScreen extends StatefulWidget {
  const MyLoadingScreenReportScreen({Key? key}) : super(key: key);

  @override
  _MyLoadingScreenReportScreenState createState() =>
      _MyLoadingScreenReportScreenState();
}

class _MyLoadingScreenReportScreenState
    extends State<MyLoadingScreenReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MySpinKitLoadingScreen(),
    );
  }
}
