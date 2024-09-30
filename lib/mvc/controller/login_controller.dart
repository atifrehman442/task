import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task/mvc/view/home_view.dart';

class LoginController extends GetxController {
  Future<void> logIn(String email, String apiKey) async {
    try {
      final url = Uri.parse('https://demo.zinipay.com/app/auth');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": "user1@example.com", "apiKey": "apikey1"}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Get.offAll(() => HomeView());
        print(responseData);
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
