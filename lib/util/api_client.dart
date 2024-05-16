import 'package:dio/dio.dart';

const String BASE_URL = "https://newsapi.org/v2/";
const String NEWS_API_KEY = "1ca8e69d5e0440a5ac0aa68b0d89666c";

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      var dio = Dio(BaseOptions(
        baseUrl: BASE_URL,
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ));
      return dio;
    }
    return _dio!;
  }
}