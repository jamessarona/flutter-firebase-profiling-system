import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MySpinKitCircle extends StatelessWidget {
  const MySpinKitCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      lineWidth: 3,
      size: 25.0,
      color: Colors.white,
    );
  }
}

class MySpinKitFadingCube extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCube(
        size: 50.0,
        color: Colors.black,
      ),
    );
  }
}

class MySpinKitLoadingScreen extends StatelessWidget {
  const MySpinKitLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitSpinningLines(
        lineWidth: 3,
        size: 50,
        color: Color(0xff1c52dd),
      ),
    );
  }
}
