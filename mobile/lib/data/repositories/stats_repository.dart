import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../../core/database/database.dart';
import '../models/bank_stats.dart';
import '../models/question_bank.dart' as models;

/// 统计数据仓库
/// 
/// 负责生成各种统计数据
class StatsRepository {
  final AppDatabase _database;

  StatsRepository({required AppDatabase database}) : _database = database;

  /// 获取题库统计信息
  Future<BankStats> getBankStats(String bankId) async {
    // 获取题库基本信息
    final bankQuery = _database.select(_database.questionBanks)
      ..where((tbl) => tbl.id.equals(bankId));
    final bankRow = await bankQuery.getSingle();
    
    final bankData = jsonDecode(bankRow.data) as Map<String, dynamic>;
    final bank = models.QuestionBank.fromJson(bankData);

    // 获取进度信息
    final progressQuery = _database.select(_database.bankProgress)
      ..where((tbl) => tbl.bankId.equals(bankId));
    final progress = await progressQuery.getSingleOrNull();

    // 获取错题数（未掌握的）
    final wrongQuery = _database.select(_database.wrongQuestions)
      ..where((tbl) => tbl.bankId.equals(bankId) & tbl.isMastered.equals(false));
    final wrongList = await wrongQuery.get();
    final wrongCount = wrongList.length;

    // 获取收藏数
    final favoriteQuery = _database.select(_database.favorites)
      ..where((tbl) => tbl.bankId.equals(bankId));
    final favoriteList = await favoriteQuery.get();
    final favoriteCount = favoriteList.length;

    return BankStats(
      bankId: bankId,
      bankName: bank.name,
      totalQuestions: bank.totalQuestions,
      answeredCount: progress?.totalAnswered ?? 0,
      correctCount: progress?.totalCorrect ?? 0,
      wrongCount: (progress?.totalAnswered ?? 0) - (progress?.totalCorrect ?? 0),
      wrongQuestionsCount: wrongCount,
      favoritesCount: favoriteCount,
    );
  }

  /// 获取所有已下载题库的统计信息
  Future<List<BankStats>> getAllBanksStats() async {
    final banks = await _database.select(_database.questionBanks).get();
    
    final statsList = <BankStats>[];
    for (final bank in banks) {
      final stats = await getBankStats(bank.id);
      statsList.add(stats);
    }
    
    return statsList;
  }

  /// 获取总体统计
  Future<Map<String, dynamic>> getOverallStats() async {
    final allStats = await getAllBanksStats();
    
    int totalBanks = allStats.length;
    int totalQuestions = 0;
    int totalAnswered = 0;
    int totalCorrect = 0;
    int totalWrong = 0;
    int totalFavorites = 0;

    for (final stats in allStats) {
      totalQuestions += stats.totalQuestions;
      totalAnswered += stats.answeredCount;
      totalCorrect += stats.correctCount;
      totalWrong += stats.wrongQuestionsCount;
      totalFavorites += stats.favoritesCount;
    }

    return {
      'total_banks': totalBanks,
      'total_questions': totalQuestions,
      'total_answered': totalAnswered,
      'total_correct': totalCorrect,
      'total_wrong': totalWrong,
      'total_favorites': totalFavorites,
      'accuracy': totalAnswered > 0 ? (totalCorrect / totalAnswered * 100) : 0.0,
      'progress': totalQuestions > 0 ? (totalAnswered / totalQuestions * 100) : 0.0,
    };
  }
}
