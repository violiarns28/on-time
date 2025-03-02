import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/auth_model.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';

final class AuthRemote extends BaseRemote {
  AuthRemote(super.local);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = '${Constants.baseUrl}/auth';
    super.onInit();
  }

  Future<UserModel> login(LoginRequest arg) async {
    final response = await post(
      '/login',
      arg.toJson(),
      decoder: (obj) => LoginResponse.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);
    if (processed is LoginResponse) {
      await local.saveToken(processed.token);
      return processed.user;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<UserModel> register(RegisterRequest arg) async {
    final response = await post(
      '/register',
      arg.toJson(),
      decoder: (obj) => RegisterResponse.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is RegisterResponse) {
      await local.saveToken(processed.token);
      return processed.user;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<bool> authenticate() async {
    final response = await get(
      '/authenticate',
      decoder: (obj) => UserModel.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is UserModel) {
      return true;
    } else {
      return false;
    }
  }
}
