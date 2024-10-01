import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_rx/get_rx.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeController extends GetxController {
  RxBool isSyncing = false.obs;
  Timer? syncTimer;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    initializeNotification();
  }

  // Initialize notifications
  void initializeNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // Function to show notifications
  void showNotification(String message) {
    const androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'SMS Sync',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      0,
      'Sync Service',
      message,
      notificationDetails,
    );
  }

  // Function to start syncing SMS
  void startSyncing() {
    if (!isSyncing.value) {
      isSyncing.value = true;
      showNotification('SMS sync is running in the background.');
      syncTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        syncSMS("Test message now", "+1234567890", "2024-07-31T10:00:00Z");
      });
    }
  }

  // Function to stop syncing SMS
  void stopSyncing() {
    if (isSyncing.value) {
      syncTimer?.cancel();
      syncTimer = null;
      isSyncing.value = false;
      showNotification('SMS sync has been stopped.');
    }
  }

  // Function to sync SMS with the provided API
  Future<void> syncSMS(String message, String from, String timestamp) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNotification('No internet connection. SMS sync will retry later.');
      return;
    }

    try {
      final url = Uri.parse('https://demo.zinipay.com/sms/sync');
      final body = jsonEncode({
        "message": message,
        "from": from,
        "timestamp": timestamp,
      });

      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          showNotification('SMS synced successfully.');
        }
      } else {
        showNotification('Failed to sync SMS. Will retry.');
      }
    } catch (e) {
      showNotification('Error occurred: $e');
    }
  }
}
