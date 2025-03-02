import 'package:get/get.dart';
import 'package:on_time/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

base class BaseLocal extends GetxService {
  late SharedPreferencesAsync prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = SharedPreferencesAsync();
  }

  Future<void> saveToken(String token) {
    return prefs.setString(PrefKeys.token, token);
  }

  Future<String?> getToken() {
    return prefs.getString(PrefKeys.token);
  }
}
