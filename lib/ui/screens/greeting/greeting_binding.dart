import 'package:get/get.dart';
import 'package:on_time/ui/screens/greeting/greeting_controller.dart';

class GreetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GreetingController());
  }
}
