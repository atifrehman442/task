// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a persistent notification to indicate the app is running
  Future<void> showPersistentNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sms_sync_channel',
      'SMS Sync',
      channelDescription:
          'This notification shows that SMS sync is active in the background',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // Makes the notification persistent
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'SMS Sync Active',
      'Your app is syncing SMS in the background',
      platformChannelSpecifics,
    );
  }

  // Remove the notification when stopping the background sync
  Future<void> removeNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
