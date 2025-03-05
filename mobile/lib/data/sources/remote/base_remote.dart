import 'package:get/get.dart';
import 'package:on_time/core/constants.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/utils/logger.dart';

base class BaseRemote extends GetConnect {
  final UserDao userDao;

  BaseRemote(this.userDao);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = Constants.baseUrl;

    httpClient.addRequestModifier<Object?>((request) async {
      final token = await userDao.getToken();
      request.headers['Authorization'] = 'Bearer $token';
      log.d(
        '''
        [BaseRemote] Request
        url: ${request.url}
        method: ${request.method}
        headers: ${request.headers}
        ''',
      );
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      log.d(
        '''
        [BaseRemote] Response
        statusCode: ${response.statusCode}
        body: ${response.body}
        ''',
      );
      return response;
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
