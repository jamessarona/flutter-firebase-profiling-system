import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/root_page.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TanodMain());
}

class TanodMain extends StatefulWidget {
  const TanodMain({Key? key}) : super(key: key);

  @override
  _TanodMainState createState() => _TanodMainState();
}

class _TanodMainState extends State<TanodMain> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    //Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
    //Works when app is on background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeMessage = message.data['report_id'];
      print('message: $routeMessage');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => DetailReportScreen(
            id: routeMessage.toString(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Root(
        auth: new FireBaseAuth(),
      ),
    );
  }
}
// class TanodMain extends StatelessWidget {
//   // This widget is the root application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Root(
//         auth: new FireBaseAuth(),
//       ),
//     );
//   }
// }
