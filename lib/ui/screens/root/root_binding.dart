import 'package:get/get.dart';
import 'package:on_time/ui/screens/root/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootController());
  }
}
