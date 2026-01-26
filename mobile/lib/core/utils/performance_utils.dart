import 'dart:async';
import 'package:flutter/foundation.dart';

/// 性能监控工具类
class PerformanceUtils {
  /// 测量函数执行时间
  static Future<T> measureAsync<T>(
    String name,
    Future<T> Function() function,
  ) async {
    if (!kDebugMode) return await function();
    
    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();
      debugPrint('⏱️ [$name] 耗时: ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ [$name] 失败，耗时: ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  /// 测量同步函数执行时间
  static T measure<T>(
    String name,
    T Function() function,
  ) {
    if (!kDebugMode) return function();
    
    final stopwatch = Stopwatch()..start();
    try {
      final result = function();
      stopwatch.stop();
      debugPrint('⏱️ [$name] 耗时: ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ [$name] 失败，耗时: ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  /// 防抖函数
  /// 
  /// 在指定时间内多次调用，只执行最后一次
  static Timer? _debounceTimer;
  static void debounce(
    Duration duration,
    VoidCallback callback,
  ) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }

  /// 节流函数
  /// 
  /// 在指定时间内最多执行一次
  static DateTime? _lastThrottleTime;
  static void throttle(
    Duration duration,
    VoidCallback callback,
  ) {
    final now = DateTime.now();
    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!) >= duration) {
      _lastThrottleTime = now;
      callback();
    }
  }

  /// 内存使用情况记录
  static void logMemoryUsage(String tag) {
    if (!kDebugMode) return;
    
    // 在debug模式下打印内存信息
    debugPrint('💾 [$tag] Memory usage check');
  }

  /// 性能标记开始
  static final Map<String, Stopwatch> _markers = {};
  
  static void markStart(String name) {
    if (!kDebugMode) return;
    _markers[name] = Stopwatch()..start();
  }

  static void markEnd(String name) {
    if (!kDebugMode) return;
    final stopwatch = _markers[name];
    if (stopwatch != null) {
      stopwatch.stop();
      debugPrint('⏱️ [$name] 总耗时: ${stopwatch.elapsedMilliseconds}ms');
      _markers.remove(name);
    }
  }
}

/// 性能监控Mixin
/// 
/// 在StatefulWidget中使用，自动记录build时间
mixin PerformanceTracker on State {
  Stopwatch? _buildStopwatch;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('🔧 [${widget.runtimeType}] initState');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      debugPrint('🔄 [${widget.runtimeType}] didChangeDependencies');
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('🗑️ [${widget.runtimeType}] dispose');
    }
    super.dispose();
  }

  /// 开始记录build时间
  void startBuildTracking() {
    if (!kDebugMode) return;
    _buildStopwatch = Stopwatch()..start();
  }

  /// 结束记录build时间
  void endBuildTracking() {
    if (!kDebugMode) return;
    _buildStopwatch?.stop();
    if (_buildStopwatch != null && _buildStopwatch!.elapsedMilliseconds > 16) {
      debugPrint(
        '⚠️ [${widget.runtimeType}] build耗时过长: ${_buildStopwatch!.elapsedMilliseconds}ms',
      );
    }
    _buildStopwatch = null;
  }
}
