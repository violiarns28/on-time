import 'package:get/get.dart';
import 'package:on_time/ui/screens/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
