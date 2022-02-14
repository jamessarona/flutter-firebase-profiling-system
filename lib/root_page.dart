import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/screens/loginScreen.dart';
import 'package:tanod_apprehension/screens/mainScreen.dart';

class Root extends StatefulWidget {
  final BaseAuth auth;
  final String reportId;
  Root({
    required this.auth,
    required this.reportId,
  });
  @override
  _RootState createState() => _RootState();
}

enum AuthSatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthSatus _authSatus = AuthSatus.notSignedIn;

  //check the current status of the user on start of the app
  //called before statefull widget
  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authSatus =
            // ignore: unnecessary_null_comparison
            userId == null ? AuthSatus.notSignedIn : AuthSatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authSatus = AuthSatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authSatus = AuthSatus.notSignedIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_authSatus) {
      case AuthSatus.notSignedIn:
        return new LoginScreen(
          auth: widget.auth,
          onSignIn: _signedIn,
        );
      case AuthSatus.signedIn:
        return widget.reportId != ''
            ? new DetailReportScreen(
                id: widget.reportId,
                isFromNotification: true,
                auth: widget.auth,
                onSignOut: _signedOut,
              )
            : new MainScreen(
                auth: widget.auth,
                onSignOut: _signedOut,
              );
    }
  }
}
