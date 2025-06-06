import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/ui/screens/attendance/attendance_controller.dart';
import 'package:on_time/ui/screens/home/home_controller.dart';
import 'package:random_avatar/random_avatar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 157;
    final attendanceController = Get.find<AttendanceController>();
    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: const Color(0xFF4098AA),
                        width: 2.5,
                      ),
                    ),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: RandomAvatar('saytoonz',
                          fit: BoxFit.cover,
                          trBackground: true,
                          height: 50,
                          width: 50),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          "Hello, ${controller.user.name}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 20.0),
                          const SizedBox(width: 4.0),
                          Obx(
                            () => Text(
                              controller.now,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  height: formHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today Attendance",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 160,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F2F4),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBFE6EE),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Icon(Icons.login_rounded),
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Clock In",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.65),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Obx(
                                      () => Text(
                                        attendanceController.todayClockInTime,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // Text(
                                    //   "On Time",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Colors.black.withOpacity(0.5),
                                    //       fontSize: 14.0,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 170,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F2F4),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBFE6EE),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Icon(Icons.logout_rounded),
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Clock Out",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.65),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Obx(
                                      () => Text(
                                        attendanceController.todayClockOutTime,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // Text(
                                    //   "Late",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Colors.black.withOpacity(0.5),
                                    //       fontSize: 14.0,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
