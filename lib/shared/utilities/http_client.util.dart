import 'dart:convert';
import 'dart:io';

import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/shared/utilities/http-details.util.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml2json/xml2json.dart';

class HttpResponse {
  late int statusCode;
  late dynamic body;

  HttpResponse({required int statusCode, required dynamic body}) {
    this.statusCode = statusCode;
    this.body = body;
  }
}

class HttpClient {
  // Data Run
  static const String apiPath = '/api/v1/';

  findById() {}

  update() {}

  // static Future<Response> create(String url, data) {
  //   return http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'title': data,
  //     }),
  //   );
  // }

  static Future<HttpResponse> post(String resourceUrl, dynamic data,
      {String? baseUrl,
      String apiPath = HttpClient.apiPath,
      String? username,
      String? password,
      Database? database,
      Dio? dioTestClient}) async {
    HttpDetails httpDetails = await HttpDetails(
            baseUrl: baseUrl,
            username: username,
            password: password,
            database: database)
        .get();

    final dioClient = dioTestClient ??
        Dio(BaseOptions(
            connectTimeout: Duration(milliseconds: 100000),
            receiveTimeout: Duration(milliseconds: 100000),
            headers: {
              HttpHeaders.authorizationHeader:
                  '${httpDetails.authTokenType} ${httpDetails.authToken}',
              HttpHeaders.contentTypeHeader: 'application/json'
            }));

    try {
      final Response<dynamic> response = await dioClient
          .post('${httpDetails.baseUrl}$apiPath$resourceUrl', data: data);

      return HttpResponse(
          statusCode: response.statusCode ?? 500, body: response.data);
    } on DioError catch (error) {
      if (error.response != null) {
        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500,
            body: error.response?.data);
      } else {
        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500, body: error.message);
      }
    }
  }

  static Future<HttpResponse> put(String resourceUrl, dynamic data,
      {String? baseUrl,
        String apiPath = HttpClient.apiPath,
      String? username,
      String? password,
      Database? database,
      Dio? dioTestClient}) async {
    HttpDetails httpDetails = await HttpDetails(
            baseUrl: baseUrl,
            username: username,
            password: password,
            database: database)
        .get();

    final dioClient = dioTestClient ??
        Dio(BaseOptions(
            connectTimeout: Duration(milliseconds: 100000),
            receiveTimeout: Duration(milliseconds: 100000),
            headers: {
              HttpHeaders.authorizationHeader:
                  '${httpDetails.authTokenType} ${httpDetails.authToken}',
              HttpHeaders.contentTypeHeader: 'application/json'
            }));

    try {
      final Response<dynamic> response = data == null
          ? await dioClient.put('${httpDetails.baseUrl}$apiPath$resourceUrl')
          : await dioClient.put('${httpDetails.baseUrl}$apiPath$resourceUrl',
              data: data);

      return HttpResponse(
          statusCode: response.statusCode ?? 500, body: response.data);
    } on DioError catch (error) {
      if (error.response != null) {
        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500,
            body: error.response?.data);
      } else {
        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500, body: error.message);
      }
    }
  }

  static Future<HttpResponse> get(String resourceUrl,
      {String? baseUrl,
        String apiPath = HttpClient.apiPath,
      String? username,
      String? password,
      Database? database,
      Dio? dioTestClient}) async {
    HttpDetails httpDetails = await HttpDetails(
            baseUrl: baseUrl,
            username: username,
            password: password,
            database: database)
        .get();

    final dioClient = dioTestClient ??
        Dio(BaseOptions(
            connectTimeout: Duration(milliseconds: 100000),
            receiveTimeout: Duration(milliseconds: 100000),
            headers: {
              HttpHeaders.authorizationHeader:
                  '${httpDetails.authTokenType} ${httpDetails.authToken}',
            }));

    try {
      final Response<dynamic> response =
          await dioClient.get('${httpDetails.baseUrl}$apiPath$resourceUrl');

      return HttpResponse(
          statusCode: response.statusCode ?? 500, body: response.data);
    } on DioError catch (error) {
      if (error.response != null) {
        dynamic errorBody = error.response?.data;
        if (error.response?.data is String) {
          try {
            final xmlToJsonConverter = Xml2Json();
            xmlToJsonConverter.parse(error.response?.data);

            errorBody = jsonDecode(xmlToJsonConverter.toParker());
          } catch (e) {}
        }

        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500, body: errorBody);
      } else {
        dynamic errorBody = error.message;

        try {
          final xmlToJsonConverter = Xml2Json();
          xmlToJsonConverter.parse(error.message!);

          errorBody = jsonDecode(xmlToJsonConverter.toParker());
        } catch (e) {}

        return HttpResponse(
            statusCode: error.response?.statusCode ?? 500, body: errorBody);
      }
    }
  }

  // static Future<http.Response> delete(String id, String url) async {
  //   final http.Response response = await http.delete(
  //     Uri.parse('$url/$id'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Basic'
  //     },
  //   );

  //   return response;
  // }

  static Future<String> getHttpDetails(
      {String? baseUrl,
      String? username,
      String? password,
      Database? database}) async {
    if (username != null && password != null) {
      return base64Encode(utf8.encode('$username:$password'));
    }

    // final User? user = await UserQuery(database: database).getOne();
    final User? user = await UserQuery(database: database).getOne();

    return base64Encode(utf8.encode('${user?.username}:${user?.password}'));
  }
}
