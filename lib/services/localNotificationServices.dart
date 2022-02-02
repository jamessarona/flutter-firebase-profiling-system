import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tanod_apprehension/screens/detailReportScreen.dart';

class LocalNotificationServices {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? reportId) async {
      if (reportId != null) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (ctx) => DetailReportScreen(
        //       id: reportId.toString(),
        //     ),
        //   ),
        // );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailReportScreen(id: reportId)));
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "tanod",
        "tanod channel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['report_id']);
    } on Exception catch (e) {
      print(e);
    }
  }
}
