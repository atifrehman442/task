import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Container(
                  width: width * 0.4,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: homeController.isSyncing.value
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 100,
                    color: homeController.isSyncing.value
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                homeController.isSyncing.value ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed to black for better visibility
                ),
              ),
              SizedBox(height: height * 0.15),
              ElevatedButton(
                onPressed: () {
                  if (homeController.isSyncing.value) {
                    homeController.stopSyncing();
                  } else {
                    homeController.startSyncing();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  homeController.isSyncing.value ? 'Stop' : 'Start',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
