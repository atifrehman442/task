// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController loginController = Get.put(LoginController());

  TextEditingController emailController = TextEditingController();

  TextEditingController apiKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.4,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/amico.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  'Log in',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.04),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text("Email",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Container(
                  height: height * 0.07,
                  width: width * 0.750,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 202, 202, 202),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text("Api Ket",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Container(
                  height: height * 0.07,
                  width: width * 0.750,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 202, 202, 202),
                  ),
                  child: TextField(
                    controller: apiKeyController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter apikey",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                SizedBox(
                  width: width * 0.750,
                  height: height * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      loginController.logIn(emailController.text.trim(),
                          apiKeyController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
