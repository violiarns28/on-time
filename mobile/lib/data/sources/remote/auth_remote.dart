import 'package:on_time/data/models/auth_model.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';
import 'package:on_time/utils/logger.dart';

final class AuthRemote extends BaseRemote {
  AuthRemote(super.userDao);

  Future<UserModel> login(LoginRequest arg) async {
    final response = await post(
      '/auth/login',
      arg.toJson(),
      decoder: (obj) {
        if (obj['errors'] != null) {
          return obj;
        }
        return LoginResponse.fromMap(obj['data']);
      },
    );

    final processed = handleStatusCode(response);

    if (processed is LoginResponse) {
      await userDao.saveToken(processed.token);
      await userDao.saveUser(processed.user);
      return processed.user;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<UserModel> register(RegisterRequest arg) async {
    final response = await post(
      '/auth/register',
      arg.toJson(),
      decoder: (obj) {
        log.i(obj);
        if (obj['errors'] != null) {
          return obj;
        }
        return RegisterResponse.fromMap(obj['data']);
      },
    );

    final processed = handleStatusCode(response);

    if (processed is RegisterResponse) {
      await userDao.saveToken(processed.token);
      await userDao.saveUser(processed.user);
      return processed.user;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<bool> authenticate() async {
    final response = await get(
      '/auth/authenticate',
      decoder: (obj) {
        if (obj['errors'] != null) {
          return obj;
        }
        return UserModel.fromMap(obj['data']);
      },
    );

    final processed = handleStatusCode(response);

    if (processed is UserModel) {
      await userDao.saveUser(processed);
      return true;
    } else {
      return false;
    }
  }
}
