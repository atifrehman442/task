import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'mvc/view/home_view.dart'; // Update with the correct path to your home view
import 'mvc/view/login_view.dart'; // Update with the correct path to your login view

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBackgroundService.initialize(
      backgroundServiceStart); // Initialize background service
  runApp(const MyApp());
}

// Background service start function
void backgroundServiceStart() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the background service
  FlutterBackgroundService service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event != null && event['action'] == 'stop') {
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(), // HomeView should be correctly imported
    );
  }
}
