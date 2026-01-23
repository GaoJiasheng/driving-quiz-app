/// API 端点定义
/// 
/// 所有API路径的统一管理
class ApiEndpoints {
  ApiEndpoints._();

  /// 健康检查
  static const String health = '/api/health';

  /// 获取题库列表
  static const String banks = '/api/banks';

  /// 下载题库
  /// 参数: bankId
  static String bankDownload(String bankId) => '/api/banks/$bankId/download';
}
