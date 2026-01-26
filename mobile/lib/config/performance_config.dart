/// 性能配置
/// 
/// 定义应用的性能相关配置参数
class PerformanceConfig {
  /// 数据库配置
  static const database = DatabasePerformance();

  /// 网络配置
  static const network = NetworkPerformance();

  /// UI配置
  static const ui = UIPerformance();

  /// 缓存配置
  static const cache = CachePerformance();
}

/// 数据库性能配置
class DatabasePerformance {
  const DatabasePerformance();

  /// 批量插入的批次大小
  final int batchSize = 100;

  /// 查询超时时间（毫秒）
  final int queryTimeout = 5000;

  /// 是否启用WAL模式（Write-Ahead Logging）
  /// WAL模式可以提升并发性能
  final bool enableWAL = true;

  /// 缓存大小（页数）
  final int cacheSize = 2000;
}

/// 网络性能配置
class NetworkPerformance {
  const NetworkPerformance();

  /// 连接超时（毫秒）
  final int connectTimeout = 30000;

  /// 接收超时（毫秒）
  final int receiveTimeout = 30000;

  /// 最大重试次数
  final int maxRetries = 3;

  /// 重试延迟（毫秒）
  final int retryDelay = 1000;

  /// 是否启用HTTP/2
  final bool enableHttp2 = true;
}

/// UI性能配置
class UIPerformance {
  const UIPerformance();

  /// 列表滚动物理效果
  /// 使用BouncingScrollPhysics可以提升流畅度
  final bool useBouncingPhysics = true;

  /// 列表缓存范围（屏幕数量）
  final double cacheExtent = 1.0;

  /// 动画时长（毫秒）
  final int animationDuration = 300;

  /// 是否启用RepaintBoundary
  /// 隔离重绘区域，提升性能
  final bool useRepaintBoundary = true;

  /// 图片缓存大小（MB）
  final int imageCacheSize = 100;

  /// 图片缓存数量
  final int imageCacheCount = 1000;
}

/// 缓存性能配置
class CachePerformance {
  const CachePerformance();

  /// Provider缓存时间（秒）
  final int providerCacheDuration = 30;

  /// 远程数据缓存时间（秒）
  final int remoteCacheDuration = 60;

  /// 统计数据缓存时间（秒）
  final int statsCacheDuration = 30;

  /// 是否启用磁盘缓存
  final bool enableDiskCache = true;

  /// 磁盘缓存最大大小（MB）
  final int diskCacheMaxSize = 50;
}
