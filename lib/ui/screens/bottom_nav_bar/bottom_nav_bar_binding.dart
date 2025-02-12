import 'package:get/get.dart';
import 'package:on_time/ui/screens/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:on_time/ui/screens/home/home_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    // final attendanceRepo = Get.find<AttendanceRepoImpl>();
    // final localService = Get.find<LocalService>();
    // final locationService = Get.find<LocationService>();
    // final generalRepo = Get.find<GeneralRepoImpl>();
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
          // attendanceRepo,
          // localService,
          // locationService,
          ),
    );
    // Get.lazyPut<AttendanceController>(
    //   () => AttendanceController(
    //     attendanceRepo,
    //     locationService,
    //     generalRepo,
    //   ),
    // );
    // Get.lazyPut<ProfileController>(
    //   () => ProfileController(
    //     Get.find<AuthRepoImpl>(),
    //     localService,
    //   ),
    // );
  }
}
