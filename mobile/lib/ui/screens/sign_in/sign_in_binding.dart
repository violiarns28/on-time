import 'package:get/get.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';
import 'package:on_time/ui/screens/sign_in/sign_in_controller.dart';

class SignInBinding extends Bindings {
  final sl = Get.find;
  @override
  void dependencies() {
    Get.lazyPut(() => UserDao());
    Get.lazyPut(() => AuthRemote(sl()));
    Get.lazyPut(() => SignInController());
  }
}
