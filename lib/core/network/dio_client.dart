import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(BaseOptions(
    baseUrl: "https://api.example.com", // Update API Base URL
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  Dio get instance => dio;
}
