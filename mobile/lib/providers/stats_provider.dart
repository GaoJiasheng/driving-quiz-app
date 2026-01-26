import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/bank_stats.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/answer_repository.dart';
import '../core/database/database.dart';
import 'database_provider.dart';

/// 指定题库的统计数据Provider
/// 
/// 根据题库ID获取该题库的统计信息
/// 使用autoDispose在不使用时自动释放
final bankStatsProvider = FutureProvider.autoDispose.family<BankStats?, String>((ref, bankId) async {
  final repository = ref.watch(statsRepositoryProvider);
  // 缓存30秒
  ref.keepAlive();
  Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  return await repository.getBankStats(bankId);
});

/// 所有题库的统计数据列表Provider
/// 使用autoDispose避免内存泄漏
final allBankStatsProvider = FutureProvider.autoDispose<List<BankStats>>((ref) async {
  final repository = ref.watch(statsRepositoryProvider);
  // 统计数据缓存30秒
  ref.keepAlive();
  Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  return await repository.getAllBanksStats();
});

/// 指定题库的进度数据Provider
/// 使用autoDispose优化内存
final bankProgressProvider = FutureProvider.autoDispose.family<BankProgressData?, String>((ref, bankId) async {
  final repository = ref.watch(answerRepositoryProvider);
  return await repository.getBankProgress(bankId);
});

/// 指定题库的错题列表Provider
/// 使用autoDispose避免内存泄漏
final wrongQuestionsProvider = FutureProvider.autoDispose.family<List<WrongQuestion>, String>((ref, bankId) async {
  final repository = ref.watch(answerRepositoryProvider);
  return await repository.getWrongQuestions(bankId);
});

/// 指定题库的收藏列表Provider
/// 使用autoDispose优化内存
final favoritesProvider = FutureProvider.autoDispose.family<List<Favorite>, String>((ref, bankId) async {
  final repository = ref.watch(answerRepositoryProvider);
  return await repository.getFavorites(bankId);
});

/// 总体统计状态
class OverallStats {
  /// 总题库数
  final int totalBanks;
  
  /// 已完成题库数
  final int completedBanks;
  
  /// 总题目数
  final int totalQuestions;
  
  /// 已答题数
  final int answeredQuestions;
  
  /// 总正确数
  final int correctAnswers;
  
  /// 总体正确率
  final double overallAccuracy;
  
  /// 错题总数
  final int totalWrongQuestions;
  
  /// 收藏总数
  final int totalFavorites;

  OverallStats({
    required this.totalBanks,
    required this.completedBanks,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.overallAccuracy,
    required this.totalWrongQuestions,
    required this.totalFavorites,
  });

  /// 总体完成度
  double get completionRate => totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

  /// 题库完成度
  double get bankCompletionRate => totalBanks > 0 ? completedBanks / totalBanks : 0.0;
}

/// 总体统计数据Provider
final overallStatsProvider = FutureProvider<OverallStats>((ref) async {
  final statsRepository = ref.watch(statsRepositoryProvider);
  final allStats = await statsRepository.getAllBanksStats();

  int totalBanks = allStats.length;
  int completedBanks = allStats.where((s) => s.completionRate >= 1.0).length;
  int totalQuestions = allStats.fold(0, (sum, s) => sum + s.totalQuestions);
  int answeredQuestions = allStats.fold(0, (sum, s) => sum + s.answeredQuestions);
  int correctAnswers = allStats.fold(0, (sum, s) => sum + s.correctAnswers);
  double overallAccuracy = answeredQuestions > 0 ? correctAnswers / answeredQuestions : 0.0;
  int totalWrongQuestions = allStats.fold(0, (sum, s) => sum + s.wrongQuestions);
  int totalFavorites = allStats.fold(0, (sum, s) => sum + s.favorites);

  return OverallStats(
    totalBanks: totalBanks,
    completedBanks: completedBanks,
    totalQuestions: totalQuestions,
    answeredQuestions: answeredQuestions,
    correctAnswers: correctAnswers,
    overallAccuracy: overallAccuracy,
    totalWrongQuestions: totalWrongQuestions,
    totalFavorites: totalFavorites,
  );
});

/// 题库重置操作Provider
/// 
/// 提供重置题库进度的方法
class BankResetNotifier extends StateNotifier<bool> {
  final AnswerRepository _answerRepository;

  BankResetNotifier(this._answerRepository) : super(false);

  /// 重置指定题库的进度
  Future<void> resetBankProgress(String bankId) async {
    state = true; // 设置为加载中
    try {
      await _answerRepository.resetBankProgress(bankId);
    } finally {
      state = false;
    }
  }
}

final bankResetProvider = StateNotifierProvider<BankResetNotifier, bool>((ref) {
  final repository = ref.watch(answerRepositoryProvider);
  return BankResetNotifier(repository);
});
