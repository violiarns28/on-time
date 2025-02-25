import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/ui/screens/greeting/greeting_controller.dart';

class GreetingScreen extends GetView<GreetingController> {
  const GreetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 422;
    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('assets/images/greeting.png'),
            height: formHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4098AA).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your productive day starts now!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The ultimate attendance tracking solution ensures accurate time logs and safeguards data with advanced security.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.SIGN_IN);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4098AA),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
