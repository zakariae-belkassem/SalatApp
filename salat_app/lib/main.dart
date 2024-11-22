import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:salat_app/Pages/template.dart';

void main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Notifications',
          channelDescription: 'Notifications for the app',
        )
      ],
      debug: true);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
        if (!isAllowed)
          {AwesomeNotifications().requestPermissionToSendNotifications()}
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Template(),
    );
  }
}
