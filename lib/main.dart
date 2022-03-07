import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tanood/net/authenticationService.dart';
import 'package:tanood/root_page.dart';
import 'package:tanood/services/localNotificationServices.dart';

//Receive message when app is on background
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(TanodMain());
}

class TanodMain extends StatefulWidget {
  const TanodMain({Key? key}) : super(key: key);

  @override
  _TanodMainState createState() => _TanodMainState();
}

class _TanodMainState extends State<TanodMain> {
  String reportId = '';
  String notifFrom = '';

  get defaultIndex => null;
  @override
  void initState() {
    super.initState();

    LocalNotificationServices.initialize(context);

    // gives the message on which the user taps
    // and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        setState(() {
          reportId = message.data['report_id'];
          print('method 1: $reportId');
        });
        //   print('message: ${reportId.runtimeType}');
      }
    });

    // Works when app is on Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        setState(() {
          reportId = message.data['report_id'];
          print('method 2: $reportId');
        });
      }
      LocalNotificationServices.display(message);
    });

    //Works when app is on background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        reportId = message.data['report_id'];
        print('method 3: $reportId');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff1c52dd),
      ),
      home: Root(
        auth: new FireBaseAuth(),
        reportId: reportId,
      ),
    );
  }
}
