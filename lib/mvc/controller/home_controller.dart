import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool isSyncing = false.obs;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    _checkConnectivity();
  }

  // Initialize notifications for showing sync status
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Monitor connectivity and automatically sync pending SMS when connection is restored
  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncPendingSMS(); // Sync SMS if the internet is restored
      }
    });
  }

  // Start the SMS syncing process and background service
  void startSyncing() {
    if (!isSyncing.value) {
      isSyncing.value = true;
      update(); // Update the UI

      // Show a notification indicating that syncing is running
      _showNotification("Syncing SMS", "SMS syncing is now active.");

      // Initialize and start the background service
      FlutterBackgroundService.initialize(backgroundServiceStart);
    }
  }

  // Stop the SMS syncing process and background service
  void stopSyncing() async {
    if (isSyncing.value) {
      isSyncing.value = false;
      update(); // Update the UI

      // Send a command to stop the service and await its completion
      final service = FlutterBackgroundService();
      service.sendData({'action': 'stop'}); // Send a stop signal

      // Await for the service to stop
      await Future.delayed(Duration(seconds: 2));

      // Check if the service is still running and stop it directly if necessary
      if (await service.isServiceRunning()) {
        service.setForegroundMode(false); // Exit foreground mode if active
        service.stopBackgroundService();
      }

      _showNotification("Syncing SMS", "SMS syncing has been stopped.");
    }
  }

  // Background service handler
  static void backgroundServiceStart() async {
    WidgetsFlutterBinding.ensureInitialized();

    final service = FlutterBackgroundService();
    service.onDataReceived.listen((event) {
      if (event != null && event['action'] == 'stop') {
        print("Stopping background service...");
        service.setForegroundMode(false);
        service.stopBackgroundService(); // Stop the service
        return;
      }
    });

    // Set up initial notification details for the service
    service.setNotificationInfo(
      title: "SMS Sync Service",
      content: "SMS syncing is running in the background",
    );

    // Background periodic task
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (!(await service.isServiceRunning())) {
        timer.cancel(); // Cancel the timer if the service is not running
        return;
      }

      print("Background service is running");

      // Perform periodic task like syncing SMS here
      // e.g., Call a method like syncSMS(message, from, timestamp);
    });
  }

  // Sync SMS data to the server
  Future<void> syncSMS(String message, String from, String timestamp) async {
    final response = await http.post(
      Uri.parse('https://demo.zinipay.com/sms/sync'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'message': message,
        'from': from,
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success']) {
        print(responseBody['message']); // SMS synced successfully
      }
    } else {
      // Handle errors here
      print("Failed to sync SMS");
    }
  }

  // Show a notification to the user
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('sms_sync', 'SMS Sync',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  // Sync all pending SMS from shared preferences
  Future<void> _syncPendingSMS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pendingSMSList = prefs.getStringList('pendingSMS');

    if (pendingSMSList != null) {
      for (String sms in pendingSMSList) {
        var smsData = json.decode(sms);
        await syncSMS(
            smsData['message'], smsData['from'], smsData['timestamp']);
      }
      // Clear pending messages after syncing
      await prefs.remove('pendingSMS');
    }
  }

  // Store pending SMS in shared preferences for later sync
  void storePendingSMS(String message, String from, String timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pendingSMSList = prefs.getStringList('pendingSMS') ?? [];

    pendingSMSList.add(json.encode({
      'message': message,
      'from': from,
      'timestamp': timestamp,
    }));

    await prefs.setStringList('pendingSMS', pendingSMSList);
  }
}
