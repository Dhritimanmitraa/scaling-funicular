import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';
import '../errors/app_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final StorageService _storageService;

  ApiClient(this._storageService) {
    _dio = Dio();
    _setupDio();
  }

  void _setupDio() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
    
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
      sendTimeout: Duration(seconds: AppConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storageService),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(AppConstants.networkErrorMessage);
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 
                       error.response?.statusMessage ?? 
                       AppConstants.serverErrorMessage;
        
        switch (statusCode) {
          case 400:
            return BadRequestException(message);
          case 401:
            return UnauthorizedException(AppConstants.authErrorMessage);
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 500:
          default:
            return ServerException(message);
        }
      
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');
      
      case DioExceptionType.unknown:
      default:
        return NetworkException(AppConstants.networkErrorMessage);
    }
  }
}

class _AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  _AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null) {
        try {
          // TODO: Implement token refresh logic
          // For now, just clear tokens and let user login again
          await _storageService.clearTokens();
        } catch (e) {
          await _storageService.clearTokens();
        }
      }
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error to analytics/crash reporting
    print('API Error: ${err.message}');
    handler.next(err);
  }
}
