
import 'package:dio/dio.dart';

import '../../features/auth/data/api_services/auth_api_service.dart';
import '../helper/shared_preferences_service.dart';
import 'network_exceptions.dart';
class NetworkManager {
  late final Dio _dio;
  // final String baseUrl = "https://f989-31-205-209-114.ngrok-free.app/api/v1";
  // final String baseUrl = "http://api.sashaboutique.co.uk/api/v1";
  final String baseUrl = "http://3.8.218.244:3000/api/v1";
  final SharedPreferencesService preferencesService;
  late AuthService authService;


  NetworkManager({required this.preferencesService}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    authService = AuthService(networkManager: this, preferencesService: preferencesService);
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
      onResponse: (response, handler) {
        // For non-successful responses, convert to DioException and reject
        if (response.statusCode != null &&
            (response.statusCode! < 200 || response.statusCode! >= 300)) {
          final error = DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          );
          return handler.reject(error);
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        // Handle 401 for token refresh
        if (error.response?.statusCode == 401) {
          try {
            await authService.refreshToken();
            // Retry the original request with new token
            final token = preferencesService.getUserToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            return handler.resolve(await _dio.fetch(error.requestOptions));
          } catch (e) {
            return handler.reject(error);
          }
        }
        return handler.reject(error);
      },
    ));
  }
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      // First try to extract error data from response
      Map<String, dynamic>? responseData;
      int? statusCode;

      if (error.response != null) {
        statusCode = error.response!.statusCode;

        // Extract data if it exists and is a map
        if (error.response!.data != null) {
          if (error.response!.data is Map<String, dynamic>) {
            responseData = error.response!.data as Map<String, dynamic>;
          } else if (error.response!.data is String) {
            // If response data is a string, try to provide it as message
            return NetworkException(error.response!.data as String);
          }
        }
      }

      // Get error message from response if available
      String errorMessage = 'An unexpected error occurred';

      if (responseData != null) {
        // Try different common fields for error messages
        errorMessage =
            responseData['payload'] ??
                responseData['message'] ??
            responseData['error'] ??
            errorMessage;
      } else if (error.message != null && error.message!.isNotEmpty) {
        errorMessage = error.message!;
      }

      // Handle based on error type first
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return TimeoutException('Request timed out. Please check your internet connection.');
        case DioExceptionType.connectionError:
          return NetworkException('No internet connection available.');
        case DioExceptionType.badResponse:
        // Now handle based on status code
          switch (statusCode) {
            case 400:
              return BadRequestException("Bad request $errorMessage");
            case 401:
              return UnauthorizedException(errorMessage);
            case 403:
              return ForbiddenException('Access denied: $errorMessage');
            case 404:
              return NotFoundException(errorMessage);
            case 500:
              return ServerException(errorMessage);
            default:
              return NetworkException(errorMessage);
          }
        case DioExceptionType.cancel:
          return NetworkException('Request was cancelled');
        case DioExceptionType.unknown:
        // For unknown errors, try to provide as much context as possible
          if (statusCode != null) {
            switch (statusCode) {
              case 400:
                return NetworkException(errorMessage);
              case 401:
                return UnauthorizedException(errorMessage);
              case 403:
                return NetworkException('Access denied: $errorMessage');
              case 404:
                return NotFoundException(errorMessage);
              case 500:
                return ServerException(errorMessage);
              default:
                return NetworkException('Error $statusCode: $errorMessage');
            }
          }
          return NetworkException(errorMessage);
        default:
          return NetworkException(errorMessage);
      }
    }

    // For non-Dio exceptions
    return NetworkException('An unexpected error occurred: ${error.toString()}');
  }

  Future<Response> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      // Check status code manually
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,

      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters
      );

      // Check status code manually
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
  Future<Response> patch<T>(
      String path, {
        dynamic data,
      }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
      );

      // Check status code manually
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      // Check status code manually
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }


}