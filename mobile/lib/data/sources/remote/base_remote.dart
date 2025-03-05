import 'package:get/get.dart';
import 'package:on_time/core/constants.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';

base class BaseRemote extends GetConnect {
  final UserDao userDao;

  BaseRemote(this.userDao);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = Constants.baseUrl;

    httpClient.addRequestModifier<Object?>((request) async {
      final token = await userDao.getToken();
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });

    super.onInit();
  }

  T handleStatusCode<T>(Response<T> input) {
    final body = input.body;
    // log.d('''
    //   [BaseRemote] handleStatusCode
    //   statusCode: ${input.statusCode}
    //   body: $body
    // ''');
    if (body != null) {
      if (body is Map && body['errors'] != null) {
        if (body['errors']['message'] != null) {
          throw Exception(body['errors']['message']);
        }
        throw Exception(body['errors']);
      }
      return body;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
