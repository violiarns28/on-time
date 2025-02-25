import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/ui/screens/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF96D4E1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 136.0,
                  height: 163.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/on_time.png'),
                        fit: BoxFit.fill),
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
