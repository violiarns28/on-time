import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

base class BaseLocal extends GetxService {
  late SharedPreferencesAsync prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = SharedPreferencesAsync();
  }
}
