import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';

class SplashController extends GetxController {
  final userDao = Get.find<UserDao>();
  final authRemote = Get.find<AuthRemote>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    final token = await userDao.getToken();
    if (token != null) {
      await _authenticateUser();
    } else {
      navigateToGreeting();
    }
  }

  Future<void> _authenticateUser() async {
    try {
      final ok = await authRemote.authenticate();
      if (ok) {
        navigateToDashboard();
      } else {
        navigateToGreeting();
      }
    } catch (e) {
      navigateToGreeting();
    }
  }

  void navigateToGreeting() {
    Get.toNamed(Routes.GREETING);
  }

  void navigateToDashboard() {
    Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
  }
}
