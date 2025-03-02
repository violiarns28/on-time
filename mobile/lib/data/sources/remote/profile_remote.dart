import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';

final class ProfileRemote extends BaseRemote {
  ProfileRemote(super.userLocal);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = '${Constants.baseUrl}/profile';
    super.onInit();
  }

  Future<UserModel> getProfile() async {
    final response = await get(
      '/me',
      decoder: (obj) => UserModel.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is UserModel) {
      await userLocal.saveUser(processed);
      return processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<UserModel> updateProfile(UpdateProfileRequest arg) async {
    final response = await put(
      '/me',
      arg.toJson(),
      decoder: (obj) => UserModel.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is UserModel) {
      await userLocal.saveUser(processed);
      return processed;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
