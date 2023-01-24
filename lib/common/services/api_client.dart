import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkException {
  final int statusCode;
  final String responseBody;

  NetworkException({
    required this.statusCode,
    required this.responseBody,
  });
}

class ApiClient {
  final http.Client httpClient;
  final Logger logger = Logger();
  final Map<String, String> _headers = {"Content-Type": "application/json"};

  Future<Map<String, dynamic>> getResource(
    String path, {
    Map<String, String>? queryParams,
    Map<String, dynamic>? data,
  }) async {
    const storage = FlutterSecureStorage();
    var secureData = await storage.read(key: 'auth_data');

    Map<String, dynamic> authData = jsonDecode(secureData!);
    String authToken = authData["token"];

    Uri uri = createUri(
      path,
      queryParams: queryParams,
    );

    print('URI: ' + uri.toString());

    final http.Response response = await httpClient.get(uri, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken"
    });

    print('Response: ' + response.body);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createResource(
    String path,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
  }) async {
    Uri uri = await createUri(path, queryParams: queryParams);

    print('URI: ' + uri.toString());

    final _dataString = jsonEncode(data);

    print('Data: ' + _dataString.toString());

    final response = await httpClient.post(
      uri,
      body: _dataString,
      headers: _headers,
    );
    print('Response: ' + response.body);

    return _handleResponse(response);
  }

  Uri createUri(
    String path, {
    Map<String, dynamic>? queryParams,
    int? pageSize,
    int? pageNumber,
  }) {
    Map<String, dynamic> _queryParams = {};

    if (queryParams != null) {
      _queryParams.addAll(queryParams);
    }

    final uri = Uri(
      scheme: 'https',
      host: 'hiring-test.a2dweb.com',
      path: "/$path",
      queryParameters: _queryParams,
    );

    return uri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if ((response.statusCode < 200 || response.statusCode > 204)) {
      logger.e("_handleResponse, HTTPS", response.statusCode);
      logger.e(response.body.toString());
      throw NetworkException(
          statusCode: response.statusCode, responseBody: response.body);
    }
    try {
      if (response.body.isNotEmpty) {
        String responseBody = response.body;
        final body = jsonDecode(responseBody);
        return body;
      } else {
        Map<String, dynamic> map = {};
        return map;
      }
    } catch (e, s) {
      logger.e("_handleResponse, HTTPS", e, s);
      return {};
    }
  }

  ApiClient({required this.httpClient});
}
