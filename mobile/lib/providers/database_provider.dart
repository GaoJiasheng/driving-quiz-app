import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database.dart';
import '../core/network/api_client.dart';
import '../data/repositories/bank_repository.dart';
import '../data/repositories/answer_repository.dart';
import '../data/repositories/stats_repository.dart';

/// 数据库实例Provider
/// 
/// 单例模式，整个应用共享同一个数据库实例
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  
  // 当Provider销毁时关闭数据库
  ref.onDispose(() {
    database.close();
  });
  
  return database;
});

/// API客户端Provider
/// 
/// 单例模式，整个应用共享同一个API客户端
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  
  // 当Provider销毁时关闭客户端
  ref.onDispose(() {
    client.close();
  });
  
  return client;
});

/// 题库Repository Provider
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return BankRepository(
    database: database,
    apiClient: apiClient,
  );
});

/// 答题记录Repository Provider
final answerRepositoryProvider = Provider<AnswerRepository>((ref) {
  final database = ref.watch(databaseProvider);
  
  return AnswerRepository(database: database);
});

/// 统计Repository Provider
final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  
  return StatsRepository(database: database);
});
