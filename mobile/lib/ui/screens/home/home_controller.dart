import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';

class HomeController extends GetxController {
  final _userDao = Get.find<UserDao>();

  final _user = Rx(UserModel.placeholder());
  UserModel get user => _user.value;
  set user(UserModel v) => _user.value = v;

  final _now = ''.obs;
  String get now => _now.value;
  set now(String v) => _now.value = v;

  @override
  Future<void> onInit() async {
    final findUser = await _userDao.getUser();
    if (findUser != null) {
      user = findUser;
    } else {
      Get.offAllNamed(Routes.SIGN_IN);
      return;
    }
    getNow();
    super.onInit();
  }

  void getNow() {
    final n = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, y');
    now = formatter.format(n);
  }
}
