// // lib/services/background_service.dart

// import 'package:background_fetch/background_fetch.dart';
// import 'package:get/get.dart';

// import '../mvc/controller/home_controller.dart';

// class BackgroundService {
//   final HomeController homeController = Get.find<HomeController>();

//   void initBackgroundFetch() {
//     BackgroundFetch.configure(
//       BackgroundFetchConfig(
//         minimumFetchInterval: 15,
//         stopOnTerminate: false,
//         startOnBoot: true,
//         enableHeadless: true,
//       ),
//       _onBackgroundFetch,
//     ).then((int status) {
//       print('[BackgroundFetch] configured with status: $status');
//     }).catchError((e) {
//       print('[BackgroundFetch] configure ERROR: $e');
//     });
//   }

//   void _onBackgroundFetch(String taskId) async {
//     String message = "Sample SMS message"; // Replace with actual SMS data
//     String from = "+123456789"; // Replace with actual sender number
//     String timestamp = DateTime.now().toUtc().toIso8601String();

//     await homeController.syncSms(message, from, timestamp);
//     print('[BackgroundFetch] SMS synced in the background.');

//     // Call this when your task is complete.
//     BackgroundFetch.finish(taskId);
//   }

//   void startBackgroundTask() {
//     BackgroundFetch.start().then((int status) {
//       print('[BackgroundFetch] start success: $status');
//     }).catchError((e) {
//       print('[BackgroundFetch] start failure: $e');
//     });
//   }

//   void stopBackgroundTask() {
//     BackgroundFetch.stop().then((int status) {
//       print('[BackgroundFetch] stop success: $status');
//     }).catchError((e) {
//       print('[BackgroundFetch] stop failure: $e');
//     });
//   }
// }
