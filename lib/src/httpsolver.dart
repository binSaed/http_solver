import 'dart:convert';
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
    return _parseAndCatcher<T>(_get(url, headers: headers), model);
  }

  static Future<T> postToApi<T extends BaseModelForHttpSolver>(
      T model, String url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      bool checkInternet = false}) async {
    if (checkInternet == true && !(await hasInternet()))
      throw Failure('No Internet connection');
    return _parseAndCatcher<T>(
        _post(url, headers: headers, body: body, encoding: encoding), model);
  }

  static Future<http.Response> _get(String url,
      {Map<String, String> headers}) async {
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> _post(String url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return await http.post(url,
        headers: headers, body: body, encoding: encoding);
  }

  static Future<T> _parseAndCatcher<T extends BaseModelForHttpSolver>(
      Future<http.Response> futureClintResponse, T model) async {
    int _statusCode;
    try {
      final clintResponse = await futureClintResponse;
      _statusCode = clintResponse.statusCode;
      if (_statusCode != 200) throw Exception;
      return model.fromJson(clintResponse.body.toString());
    } on SocketException {
      throw Failure('No Internet connection', code: _statusCode);
    } on HttpException {
      throw Failure("Couldn't find the post", code: _statusCode);
    } on FormatException {
      throw Failure("Bad response format");
    } catch (c) {
      throw Failure("UnHandled Exception ${c.toString()}",
          code: _statusCode ?? 0);
    }
  }
}
