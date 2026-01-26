import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_endpoints.dart';
import '../../config/app_config.dart';
import '../../config/performance_config.dart';

/// API 客户端
/// 
/// 封装所有网络请求，统一处理错误和响应
class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.baseUrl,
        connectTimeout: Duration(milliseconds: PerformanceConfig.network.connectTimeout),
        receiveTimeout: Duration(milliseconds: PerformanceConfig.network.receiveTimeout),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // 性能优化：启用持久连接
        persistentConnection: true,
        // 最大重定向次数
        maxRedirects: 5,
        // 跟随重定向
        followRedirects: true,
      ),
    );

    // 性能优化：配置HTTP适配器
    if (_dio.httpClientAdapter case DefaultHttpClientAdapter adapter) {
      adapter.onHttpClientCreate = (client) {
        // 启用HTTP/2
        client.connectionTimeout = Duration(milliseconds: PerformanceConfig.network.connectTimeout);
        // 增加最大连接数
        client.maxConnectionsPerHost = 5;
        return client;
      };
    }

    // 添加日志拦截器（仅开发环境）
    if (AppConfig.isDevelopment) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // 添加错误处理拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // 统一错误处理
          final apiError = _handleError(error);
          handler.next(apiError);
        },
      ),
    );
  }

  /// 健康检查
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _dio.get(ApiEndpoints.health);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取题库列表
  Future<List<Map<String, dynamic>>> getBankList() async {
    try {
      final response = await _dio.get(ApiEndpoints.banks);
      final data = response.data as Map<String, dynamic>;
      
      if (data['code'] == 200) {
        final banks = data['data']['question_banks'] as List;
        return banks.cast<Map<String, dynamic>>();
      } else {
        throw ApiException(
          message: data['message'] ?? '获取题库列表失败',
          code: data['code'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 下载题库
  /// 
  /// [bankId] 题库ID
  /// [onProgress] 下载进度回调
  Future<Map<String, dynamic>> downloadBank(
    String bankId, {
    ProgressCallback? onProgress,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.bankDownload(bankId),
        onReceiveProgress: onProgress,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// 错误处理
  DioException _handleError(DioException error) {
    String message;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '网络连接超时，请检查网络后重试';
        break;
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          message = '请求的资源不存在';
        } else if (statusCode == 500) {
          message = '服务器错误，请稍后重试';
        } else {
          message = '请求失败（错误码: $statusCode）';
        }
        break;
        
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
        
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          message = '网络连接失败，请检查网络设置';
        } else {
          message = '网络请求失败，请重试';
        }
        break;
        
      default:
        message = '未知错误，请重试';
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: message,
    );
  }

  /// 关闭客户端
  void close() {
    _dio.close();
  }
}

/// API异常
class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ApiException: $message (code: $code)';
}
