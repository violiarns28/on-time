import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';

final class ProfileRemote extends BaseRemote {
  ProfileRemote(super.userDao);

  Future<UserModel> getProfile() async {
    final response = await get(
      '/profile/me',
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
      return processed;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<UserModel> updateProfile(UpdateProfileRequest arg) async {
    final response = await put(
      '/profile/me',
      arg.toJson(),
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
      return processed;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
