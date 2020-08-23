import 'dart:io';

import 'package:bluestacks_assignment/model/user.dart';
import 'package:bluestacks_assignment/utils/shared_preferece_helper.dart';
import 'package:dio/dio.dart';

import 'api_response.dart';
import 'app_exceptions.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();

  var _client;

  static const String BASE_API_URL =
      'https://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/';

  static const String REFRESH_TOKEN_URL = 'refreshTokenUrl';

  static const String LOGIN = 'login';
  static const String TOURNAMENTS = 'tournaments_list_v2';
  static const String PROFILE_URL = 'https://run.mocky.io/v3/104fe47e-e5ab-465c-b1f3-399af4787afe';

  factory ApiClient() {
    return _singleton;
  }

  SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  ApiClient._internal();

  Future<Dio> getApiClient() async {
    if (_client == null) {
      _client = Dio();

      _client.interceptors.clear();
      _client.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        request: true,
        error: true,
        requestHeader: true,
        responseHeader: true,
      ));
      var headerInterceptor =
          InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // Do something before request is sent
        var token = await _sharedPreferencesHelper.getAccessToken();
        print("Token -------------$token-------------");
        if (token != null) options.headers["Authorization"] = "Bearer $token";
        if (!(options.data is FormData))
          options.headers["Content-Type"] = 'application/json';

        return options;
      }, onResponse: (Response response) {
        // Do something with response data
        return response; // continue
      }, onError: (DioError error) async {
        // Do something with response error
        if (error.response?.statusCode == 401 &&
            !error.request.uri.toString().endsWith(LOGIN)) {
          _client.interceptors.requestLock.lock();
          _client.interceptors.responseLock.lock();
          RequestOptions options = error.response.request;

          try {
            AuthResponse authResponse = await getRefreshToken();
            if (authResponse != null) {
              await _sharedPreferencesHelper.setAuthResponse(authResponse);
              _client.interceptors.requestLock.unlock();
              _client.interceptors.responseLock.unlock();
              options.headers['Authorization'] =
                  "Bearer " + authResponse.accessToken;
              return _client.request(options.path, options: options);
            } else {
              return error;
            }
          } on UnauthorisedException catch (ex) {
            throw ex;
          } on FetchDataException catch (ex) {}
        } else {
          return error;
        }
      });

      _client.interceptors.add(headerInterceptor);
    }
    return _client;
  }

  Future<AuthResponse> getRefreshToken() async {
    print('Api refresh token');
    AuthResponse authResponse;
    try {
      String refreshToken = await _sharedPreferencesHelper.getRefreshToken();

      var headers = new Map();
      headers["Content-Type"] = 'application/json';
      var client = Dio();
      client.interceptors.clear();
      client.interceptors.add(LogInterceptor(responseBody: true));
      print(refreshToken);
      final response = await client.post(
        BASE_API_URL + ApiClient.REFRESH_TOKEN_URL,
        data: {'refreshToken': refreshToken},
        options: Options(headers: headers),
      );
      authResponse = _returnResponse(response);
    } on UnauthorisedException catch (ex) {
      throw ex;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api get recieved!');
    return authResponse;
  }

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic> queryParams,
      String tag,
      String completeUrl}) async {
    print('Api Get, url $endpoint');
    dynamic responseJson;
    try {
      var client = await getApiClient();
      final response = await client.get(
        completeUrl == null ? BASE_API_URL + endpoint : completeUrl,
        queryParameters: queryParams,
      );
      responseJson = _returnResponse(response);
      print('api get recieved!');
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('return response!');

    return responseJson;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    print('Api Post, url ${BASE_API_URL + endpoint}');
    print(body.toString());
    var responseJson;
    try {
      var client = await getApiClient();
      final response = await client.post(
        BASE_API_URL + endpoint,
        data: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    print('Api Patch, url $endpoint');
    var responseJson;
    try {
      var client = await getApiClient();
      final response = await client.patch(
        BASE_API_URL + endpoint,
        data: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api patch.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    print('Api put, url $endpoint');
    var responseJson;
    try {
      var client = await getApiClient();
      final response = await client.put(
        BASE_API_URL + endpoint,
        data: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    print('Api delete, url $endpoint');
    var apiResponse;
    try {
      var client = await getApiClient();
      final response = await client.delete(BASE_API_URL + endpoint, data: body);
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api delete.');
    return apiResponse;
  }

  Future<dynamic> multipart(
      String endpoint, Map<String, dynamic> body, File imageFile) async {
    print('Api Post, url ${BASE_API_URL + endpoint}');
    print(body);
    var responseJson;
    try {
      var client = await getApiClient();
      // multipart that takes file
      var multipartFile = await MultipartFile.fromFile(imageFile.path);
      body['file'] = multipartFile;

      var formData = FormData.fromMap(body);

      var response = await client.post(
        BASE_API_URL + endpoint,
        data: formData,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on Exception catch (ex) {
      if (ex is DioError) {
        _returnResponse(ex.response);
      }
      throw ex;
    }
    print('api post.');
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    var responseString = response.data.toString();
    print(responseString);
    //var responseJson = json.decode(responseString);
    //print(responseJson);
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = apiResponse.fromJson(response.data);
    } catch (ex) {
      print(ex);
    }
    switch (response.statusCode) {
      case 200:
        if (!apiResponse.success) {
          throw FetchDataException(apiResponse.message);
        }
        return apiResponse.data;
      case 202:
      case 201:
        if (!apiResponse.success) {
          throw FetchDataException(apiResponse.message);
        }
        return apiResponse.data;
      case 404:
        throw FetchDataException("Something went wrong!");
      case 400:
        if (apiResponse.message != null) {
          throw FetchDataException(apiResponse.message);
        }
        throw FetchDataException(response.data.toString());
      case 401:
        throw UnauthorisedException(response.data.toString());
      case 403:
        throw FetchDataException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
