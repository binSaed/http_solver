import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_solver/src/util/check_internet.dart';

import 'models/models.dart';

class HttpSolver {
  static Future<T> getFromApi<T extends BaseModelForHttpSolver>(
      T model, String url,
      {Map<String, String> headers, bool checkInternet = false}) async {
    if (checkInternet == true && !(await hasInternet()))
      throw Failure('No Internet connection');
    int _statusCode;
    String _body;
    try {
      await http.get(url, headers: headers).then((_response) {
        _body = _response.body.toString();
        _statusCode = _response.statusCode;
      });
      return model.fromJson(_body);
    } on SocketException {
      throw Failure('No Internet connection0', code: _statusCode);
    } on HttpException {
      throw Failure("Couldn't find the post", code: _statusCode);
    } on FormatException {
      throw Failure("Bad response format");
    } catch (c) {
      throw Failure("UnHandled Exception ${c.toString()}");
    }
  }
}
