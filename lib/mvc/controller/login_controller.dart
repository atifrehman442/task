import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task/custom/snackbar.dart';
import 'package:task/mvc/view/home_view.dart';

class LoginController extends GetxController {
  // Login Function
  Future<void> logIn(String email, String apiKey) async {
    try {
      final url = Uri.parse('https://demo.zinipay.com/app/auth');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "apiKey": apiKey}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.offAll(() => HomeView());

        AppSnackBar.showCustomSnackBar(
          title: 'Login Successful',
          message: 'Welcome, you have successfully logged in!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        print(responseData);
      } else {
        AppSnackBar.showCustomSnackBar(
          title: 'Login Failed',
          message: 'Invalid email or API key. Please try again.',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );

        print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      AppSnackBar.showCustomSnackBar(
        title: 'Error',
        message: 'An error occurred: $e',
        backgroundColor: Colors.red,
        icon: Icons.warning,
      );

      print("An error occurred: $e");
    }
  }
}
