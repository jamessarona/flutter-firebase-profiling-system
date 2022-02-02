import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tanod_apprehension/net/authenticationService.dart';
import 'package:tanod_apprehension/root_page.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';
import 'package:tanod_apprehension/services/localNotificationServices.dart';
import 'package:tanod_apprehension/shared/constants.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_important_channel', //id
//     'High Importance Notifications', //title
//     //  'High Importance Notifications', //title ,
//     //'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

//Receive message when app is on background
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  runApp(TanodMain());
}

class TanodMain extends StatefulWidget {
  const TanodMain({Key? key}) : super(key: key);

  @override
  _TanodMainState createState() => _TanodMainState();
}

class _TanodMainState extends State<TanodMain> {
  String routeMessage = '';
  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseMessaging.onMessage.listen(
  //     (RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification!.android;
  //       if (notification != null && android != null) {
  //         flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,
  //               color: customColor[130],
  //               playSound: true,
  //               // icon: '@mipmap/ic_launcher',
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenApp event was published!');
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification?.title != null && android != null) {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return AlertDialog(
  //               title: Text('Title'),
  //               content: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [Text('Notif Body')],
  //                 ),
  //               ),
  //             );
  //           });
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();

    LocalNotificationServices.initialize(context);

    // gives the message on which the user taps
    // and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        routeMessage = message.data['report_id'];
        print('message: ${routeMessage.runtimeType}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => DetailReportScreen(
              id: routeMessage.toString(),
            ),
          ),
        );
      }
    });

    // Works when app is on Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      LocalNotificationServices.display(message);
    });

    //Works when app is on background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      routeMessage = message.data['report_id'];

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => DetailReportScreen(
            id: routeMessage.toString(),
          ),
        ),
      );
    });

    //
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
