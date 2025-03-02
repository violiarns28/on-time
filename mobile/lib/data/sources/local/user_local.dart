import 'dart:convert';

import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/base_local.dart';

final class UserLocal extends BasePrefsLocal {
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
}
