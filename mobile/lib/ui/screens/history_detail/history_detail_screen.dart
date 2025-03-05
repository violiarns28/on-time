import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_controller.dart';

class HistoryDetailScreen extends GetView<HistoryDetailController> {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "History Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<List<AttendanceModel>>(
        stream: controller.attendancesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final attendances = snapshot.data;
          if (attendances == null || attendances.isEmpty) {
            return const Center(
              child: Text("No history found"),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: attendances.map((attendance) {
                return _buildHistoryItem(
                  attendance.userName,
                  attendance.previousHash,
                  attendance.hash,
                  showClockIn: attendance.type == AttendanceType.CLOCK_IN,
                  showClockOut: attendance.type == AttendanceType.CLOCK_OUT,
                  timestamp: attendance.timestamp,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
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
  final prettyDate =
      "${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute} WIB";

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
