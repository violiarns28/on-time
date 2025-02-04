import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_time/core/routes/app_pages.dart';

class GreetingScreen extends StatelessWidget {
  const GreetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/greeting.png'),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Container(
                width: 430.0,
                height: 266.0,
                decoration: BoxDecoration(
                  color: Color(0xFF96D4E0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(190.0),
                    bottomRight: Radius.circular(190.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                          color: Color(0xFF036579),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 180.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/title.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Precision Attendance, Anytime Access",
                      style: TextStyle(
                          color: Color(0xFF036579),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 88),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: 256,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGN_UP);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF29B6D3)),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36.0),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: 256,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGN_IN);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFFFFFF)),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Color(0xFF0B98C7),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
