import 'package:get/get.dart';
import 'package:on_time/ui/screens/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
