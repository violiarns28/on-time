import 'package:get/get.dart';
import 'package:on_time/ui/screens/attendance/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceController());
  }
}
