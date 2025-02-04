import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:on_time/core/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "OnTime",
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}
