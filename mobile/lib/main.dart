import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_time/core/routes/routes.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/local/db/app_database.dart';
import 'package:on_time/data/sources/remote/attendance_remote.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';
import 'package:on_time/data/sources/remote/profile_remote.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "OnTime",
    theme: ThemeData(
      textTheme: GoogleFonts.quicksandTextTheme(
        ThemeData.light().textTheme,
      ),
    ),
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}

void setupLocator() {
  final sl = Get.find;

  // Local
  Get.put(AppDatabase());
  Get.lazyPut(() => UserDao());
  Get.lazyPut(() => AttendanceDao(sl()));

  // Remote
  Get.lazyPut(() => AuthRemote(sl()));
  Get.lazyPut(() => AttendanceRemote(sl(), sl()));
  Get.lazyPut(() => ProfileRemote(sl()));
}
