import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void showCustomSnackBar({
    required String title,
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      isDismissible: true,
    );
  }
}
