/// 应用配置
class AppConfig {
  // API 配置
  static const String apiBaseUrl = 'http://localhost:8080';
  static const String apiVersion = 'v1';
  
  // 超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // 数据库配置
  static const String databaseName = 'quiz_app.db';
  static const int databaseVersion = 1;
  
  // 应用信息
  static const String appName = '驾考刷刷';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstLaunch = 'first_launch';
  
  // 默认题库ID
  static const String defaultBankId = 'demo_bank';
}
