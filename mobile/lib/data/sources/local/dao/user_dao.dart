import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/prefs/base_prefs_local.dart';
import 'package:uuid/uuid.dart';

final class UserDao extends BasePrefsLocal {
  final deviceInfo = DeviceInfoPlugin();
  Future<void> saveToken(String token) {
    return prefs.setString(PrefKeys.token, token);
  }

  Future<String?> getToken() {
    return prefs.getString(PrefKeys.token);
  }

  Future<void> saveUser(UserModel user) {
    return prefs.setString(PrefKeys.user, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final userStr = await prefs.getString(PrefKeys.user);

    if (userStr != null) {
      final userMap = jsonDecode(userStr);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }

  Future<void> clearUser() {
    return prefs.remove(PrefKeys.user);
  }

  Future<void> saveDeviceId(String deviceId) {
    return prefs.setString(PrefKeys.deviceId, deviceId);
  }

  Future<String?> getDeviceId() async {
    String? deviceId = '';
    deviceId = await prefs.getString(PrefKeys.deviceId);
    if (deviceId != null) {
      return deviceId;
    } else {
      deviceId = const Uuid().v7();
    }
    await saveDeviceId(deviceId);
    return deviceId;
  }
}
