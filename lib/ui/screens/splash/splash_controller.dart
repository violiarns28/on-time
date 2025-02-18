import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';

class SplashController extends GetxController {
  final isInitialized = false.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      isInitialized.value = true;
      navigateToGreeting();
    });

    super.onInit();
  }

  void navigateToGreeting() {
    if (isInitialized.value) {
      Get.toNamed(Routes.GREETING);
    }
  }
}
