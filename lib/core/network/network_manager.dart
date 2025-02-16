
import 'package:dio/dio.dart';

import '../../features/auth/data/api_services/auth_api_service.dart';
import '../helper/shared_preferences_service.dart';
import 'network_exceptions.dart';
class NetworkManager {
  late final Dio _dio;
  final String baseUrl = "";
  final SharedPreferencesService preferencesService;
  final AuthService authService;


  NetworkManager({required this.preferencesService,required this.authService}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print('Dio Log: $object'),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = preferencesService.getUserToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            await authService.refreshToken();
            // Retry the original request with new token
            final token = preferencesService.getUserToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            return handler.resolve(await _dio.fetch(error.requestOptions));
          } catch (e) {
            return handler.reject(_createDioException(401, 'Session expired. Please log in again.'));
          }
        }
        return handler.reject(_createDioException(
          error.response?.statusCode,
          error.response?.data?['message'] ?? 'An error occurred',
        ));
      },
    ));
  }

  DioException _createDioException(int? statusCode, String message) {
    return DioException(
      requestOptions: RequestOptions(path: ''),
      error: message,
      type: DioExceptionType.unknown,
      message: message,
    );
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return TimeoutException('Request timed out. Please check your internet connection.');
        case DioExceptionType.connectionError:
          return NetworkException('No internet connection available.');
        default:
          switch (error.response?.statusCode) {
            case 400:
              return NetworkException(error.message ?? 'Invalid request');
            case 401:
              return UnauthorizedException(error.message ?? 'Unauthorized');
            case 403:
              return NetworkException(error.message ?? 'Access denied');
            case 404:
              return NotFoundException(error.message ?? 'Resource not found');
            case 500:
              return ServerException(error.message ?? 'Server error');
            default:
              return NetworkException(error.message ?? 'An unexpected error occurred');
          }
      }
    }
    return NetworkException('An unexpected error occurred');
  }

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }


}