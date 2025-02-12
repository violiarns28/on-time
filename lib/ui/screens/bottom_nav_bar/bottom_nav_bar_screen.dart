import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/ui/screens/attendance/attendance_screen.dart';
import 'package:on_time/ui/screens/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:on_time/ui/screens/home/home_screen.dart';
import 'package:on_time/ui/screens/profile/profile_screen.dart';

class BottomNavBarScreen extends GetView<BottomNavBarController> {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            AttendanceScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(
              Icons.home_filled,
              color: controller.selectedIndex.value == 0
                  ? Colors.white
                  : Colors.black,
            ),
            Icon(
              Icons.alarm_on_rounded,
              color: controller.selectedIndex.value == 1
                  ? Colors.white
                  : Colors.black,
            ),
            Icon(
              Icons.person_2_rounded,
              color: controller.selectedIndex.value == 2
                  ? Colors.white
                  : Colors.black,
            ),
          ],
          backgroundColor: Colors.white,
          index: controller.selectedIndex.value,
          onTap: controller.changePage,
          color: const Color(0xFFBFE6EE).withOpacity(0.7),
          buttonBackgroundColor: const Color(0xFF4098AA),
          height: 65,
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeInOut,
        ),
      );
    });
  }
}
