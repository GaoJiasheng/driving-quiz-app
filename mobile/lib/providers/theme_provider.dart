import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题模式Provider
/// 
/// 管理应用的深色/浅色模式
class ThemeNotifier extends StateNotifier<bool> {
  static const String _key = 'is_dark_mode';
  
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  /// 从本地存储加载主题设置
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_key) ?? false;
      state = isDark;
    } catch (e) {
      // 如果加载失败，使用默认浅色主题
      state = false;
    }
  }

  /// 切换主题模式
  Future<void> toggleTheme() async {
    state = !state;
    await _saveTheme();
  }

  /// 设置主题模式
  Future<void> setTheme(bool isDark) async {
    state = isDark;
    await _saveTheme();
  }

  /// 保存主题设置到本地存储
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, state);
    } catch (e) {
      // 保存失败不影响使用
      print('Failed to save theme: $e');
    }
  }
}

/// 主题模式Provider实例
/// 
/// 返回当前是否为深色模式
/// 
/// 使用示例：
/// ```dart
/// final isDarkMode = ref.watch(themeProvider);
/// ```
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

/// 主题切换Provider
/// 
/// 用于在设置页面切换主题
/// 
/// 使用示例：
/// ```dart
/// ref.read(themeProvider.notifier).toggleTheme();
/// ```
