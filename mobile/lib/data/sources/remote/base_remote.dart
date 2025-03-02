import 'package:get/get.dart';
import 'package:on_time/core/constants.dart';
import 'package:on_time/data/sources/local/base_local.dart';

base class BaseRemote extends GetConnect {
  final BaseLocal local;

  BaseRemote(this.local);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = Constants.baseUrl;
    final token = await local.getToken();
    if (token != null) {
      httpClient.addRequestModifier<Object?>((request) {
        request.headers['Authorization'] = 'Bearer $token';
        return request;
      });
    }

    super.onInit();
  }

  T? handleStatusCode<T>(Response<T> input) {
    final body = input.body;
    if (input.statusCode == 200) {
      return body;
    } else {
      if (body is Map) {
        final error = body['error'];
        throw Exception(error);
      } else {
        throw Exception('Something went wrong');
      }
    }
  }
}
