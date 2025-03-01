import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_time/core/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
