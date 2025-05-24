import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/ui/screens/attendance/attendance_controller.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_binding.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_screen.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 135;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: height / 10,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xFF0E5D6D),
                  Color(0xFF3C94A5),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                topLeft: Radius.circular(0),
                bottomRight: Radius.circular(50),
                topRight: Radius.circular(0),
              ),
            ),
            child: Text(
              "Attendance",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  width: double.infinity,
                  height: formHeight,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                            () => _buildClockContainer(
                                "Clock In",
                                controller.todayClockInTime,
                                const Color(0xFF2DBF4D)),
                          ),
                          const SizedBox(width: 16.0),
                          Obx(
                            () => _buildClockContainer(
                                "Clock Out",
                                controller.todayClockOutTime,
                                const Color(0xFFE74C3C)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 300,
                        height: 42,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: (controller.isLoading ||
                                    controller.isTodayClockInAndOut)
                                ? null
                                : () {
                                    final controller =
                                        Get.find<AttendanceController>();
                                    controller.saveAttendance(context);
                                  },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                controller.isTodayClockInAndOut
                                    ? const Color(0xFF4098AA).withOpacity(0.5)
                                    : const Color(0xFF4098AA),
                              ),
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    controller.isTodayClockInAndOut
                                        ? "Already Presence Today"
                                        : controller.isTodayClockIn
                                            ? "Clock Out"
                                            : "Clock In",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "History",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => const HistoryDetailScreen(),
                                  binding: HistoryDetailBinding());
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Obx(
                          () => SingleChildScrollView(
                            child: Column(
                              children:
                                  controller.attendances.map((attendance) {
                                return _buildHistoryItem(
                                  attendance.userName,
                                  attendance.previousHash,
                                  attendance.hash,
                                  showClockIn: attendance.type ==
                                      AttendanceType.CLOCK_IN,
                                  showClockOut: attendance.type ==
                                      AttendanceType.CLOCK_OUT,
                                  timestamp: attendance.timestamp,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
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

  Widget _buildClockContainer(String title, String time, Color timeColor) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 130,
      height: 96,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.65),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: timeColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String name,
    String prevHash,
    String blockchainHash, {
    bool showClockIn = false,
    bool showClockOut = false,
    int timestamp = 0,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formatter = DateFormat("dd-MM-yyyy HH:mm:ss");
    final formattedDate = formatter.format(date);
    final formattedDatePart = formattedDate.split(" ");
    final prettyDate =
        "${formattedDatePart.first} at ${formattedDatePart.last} WIB";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2F4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Name : $name",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Previous Hash : $prevHash",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Blockchain Hash : $blockchainHash",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            if (showClockIn) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9E5CA),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: Text(
                    "CLOCK IN : $prettyDate",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            if (showClockOut) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEB5B7),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: Text(
                    "CLOCK OUT : $prettyDate",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
