import 'package:get/get.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

base class BasePrefsLocal extends GetxService {
  late SharedPreferencesAsync prefs;
  late UserDao userDao;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = SharedPreferencesAsync();
    userDao = UserDao();
  }
}
