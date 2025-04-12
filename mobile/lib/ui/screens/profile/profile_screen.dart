import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/data/sources/local/db/app_database.dart';
import 'package:on_time/ui/screens/change_password/change_password_screen.dart';
import 'package:on_time/ui/screens/profile/profile_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  Future<void> handleDumpDB() async {
    try {
      final dbDir = await getApplicationSupportDirectory();
      final dbFile = File("${dbDir.path}/ontime.db");

      debugPrint("[handleDumpDB] - Source DB Path: ${dbFile.path}");

      if (!await dbFile.exists()) {
        debugPrint("[handleDumpDB] - Database file does not exist.");
        return;
      }

      final dbLength = await dbFile.length();
      debugPrint("[handleDumpDB] - DB File Size: $dbLength bytes");

      // Copy DB to Downloads
      final backupFile = File("/storage/emulated/0/Download/ontime_backup.db");
      await dbFile.copy(backupFile.path);
      debugPrint("[handleDumpDB] - Database copied to: ${backupFile.path}");

      // Export attendance table to CSV
      final db =
          AppDatabase(); // Ensure AppDatabase is your Drift database class
      final rows = await db.select(db.attendanceTable).get();

      final csvBuffer = StringBuffer();
      csvBuffer.writeln(
          "id,userId,latitude,longitude,type,date,timestamp,hash,previousHash,nonce,userName");

      for (var row in rows) {
        csvBuffer.writeln([
          row.id,
          row.userId,
          row.latitude,
          row.longitude,
          row.type.index,
          row.date,
          row.timestamp,
          row.hash,
          row.previousHash,
          row.nonce,
          row.userName
        ].join(","));
      }

      final csvFile =
          File("/storage/emulated/0/Download/attendance_backup.csv");
      await csvFile.writeAsString(csvBuffer.toString());

      debugPrint("[handleDumpDB] - CSV exported to: ${csvFile.path}");
    } catch (e, stackTrace) {
      debugPrint("[handleDumpDB] - Error while dumping DB: $e");
      debugPrint("[handleDumpDB] - Stack Trace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 120;

    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Stack(
        children: [
          Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 64),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      controller.user.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.fromLTRB(24, 0, 8, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0xFFE8F2F4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Expanded(
                            child: Text(
                              controller.user.deviceId.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.copyDeviceId,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8F2F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              color: Color(0xFF4098AA),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.edit_rounded,
                            size: 24,
                            color: Color(0xFF4098AA),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBCECE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: controller.signOut,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              color: Color(0xFF9A0C0C),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.logout_rounded,
                            size: 24,
                            color: Color(0xFF9A0C0C),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBCECE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: handleDumpDB,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dump",
                            style: TextStyle(
                              color: Color(0xFF9A0C0C),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.logout_rounded,
                            size: 24,
                            color: Color(0xFF9A0C0C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(130, 0, 130, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xFF4098AA),
                    width: 4,
                  ),
                ),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: RandomAvatar('saytoonz',
                      fit: BoxFit.cover,
                      trBackground: true,
                      height: 60,
                      width: 60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
