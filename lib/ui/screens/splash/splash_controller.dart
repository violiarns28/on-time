import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:on_time/core/routes/app_pages.dart';

class SplashController extends GetxController {
  final isInitialized = false.obs;

  @override
  void onInit() {
    print("SplashController onInit");
    Future.delayed(Duration(seconds: 2), () {
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

  @override
  void onReady() {
    print("SplashController onReady");
    super.onReady();
  }

  @override
  void onClose() {
    print("SplashController onClose");
    super.onClose();
  }
}
