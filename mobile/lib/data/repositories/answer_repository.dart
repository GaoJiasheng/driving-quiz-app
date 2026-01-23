import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../../core/database/database.dart';

/// 答题记录数据仓库
/// 
/// 负责答题记录、错题本、收藏等数据操作
class AnswerRepository {
  final AppDatabase _database;

  AnswerRepository({required AppDatabase database}) : _database = database;

  // ========== 答题记录 ==========

  /// 保存答题记录
  Future<void> saveAnswerRecord({
    required String bankId,
    required String questionId,
    required List<int> userAnswer,
    required bool isCorrect,
  }) async {
    final companion = AnswerRecordsCompanion.insert(
      bankId: bankId,
      questionId: questionId,
      userAnswer: drift.Value(jsonEncode(userAnswer)),
      isCorrect: isCorrect,
      answeredAt: DateTime.now(),
    );

    await _database.into(_database.answerRecords).insert(
          companion,
          mode: drift.InsertMode.replace,
        );

    // 如果答错，自动加入错题本
    if (!isCorrect) {
      await addToWrongQuestions(bankId, questionId);
    }

    // 更新题库进度
    await _updateBankProgress(bankId, isCorrect);
  }

  /// 获取某题的答题记录
  Future<AnswerRecord?> getAnswerRecord(
    String bankId,
    String questionId,
  ) async {
    final query = _database.select(_database.answerRecords)
      ..where((tbl) =>
          tbl.bankId.equals(bankId) & tbl.questionId.equals(questionId));

    return await query.getSingleOrNull();
  }

  /// 更新题库进度
  Future<void> _updateBankProgress(String bankId, bool isCorrect) async {
    final existing = await (_database.select(_database.bankProgress)
          ..where((tbl) => tbl.bankId.equals(bankId)))
        .getSingleOrNull();

    if (existing == null) {
      // 创建新进度记录
      final companion = BankProgressCompanion(
        bankId: drift.Value(bankId),
        totalAnswered: drift.Value(1),
        totalCorrect: drift.Value(isCorrect ? 1 : 0),
        updatedAt: drift.Value(DateTime.now()),
      );
      await _database.into(_database.bankProgress).insert(companion);
    } else {
      // 更新现有记录
      final companion = BankProgressCompanion(
        bankId: drift.Value(existing.bankId),
        totalAnswered: drift.Value(existing.totalAnswered + 1),
        totalCorrect: drift.Value(existing.totalCorrect + (isCorrect ? 1 : 0)),
        updatedAt: drift.Value(DateTime.now()),
      );
      await _database.update(_database.bankProgress).replace(companion);
    }
  }

  // ========== 错题本 ==========

  /// 添加到错题本
  Future<void> addToWrongQuestions(String bankId, String questionId) async {
    final companion = WrongQuestionsCompanion.insert(
      bankId: bankId,
      questionId: questionId,
      addedAt: DateTime.now(),
    );

    await _database.into(_database.wrongQuestions).insert(
          companion,
          mode: drift.InsertMode.insertOrIgnore,
        );
  }

  /// 获取错题列表
  Future<List<WrongQuestion>> getWrongQuestions(String bankId) async {
    final query = _database.select(_database.wrongQuestions)
      ..where((tbl) => tbl.bankId.equals(bankId) & tbl.isMastered.equals(false))
      ..orderBy([
        (tbl) => drift.OrderingTerm.asc(tbl.addedAt),
      ]);

    return await query.get();
  }

  /// 标记错题为已掌握
  Future<void> markWrongQuestionAsMastered(
    String bankId,
    String questionId,
  ) async {
    final query = _database.update(_database.wrongQuestions)
      ..where((tbl) =>
          tbl.bankId.equals(bankId) & tbl.questionId.equals(questionId));

    await query.write(const WrongQuestionsCompanion(
      isMastered: drift.Value(true),
    ));
  }

  /// 检查是否在错题本中
  Future<bool> isInWrongQuestions(String bankId, String questionId) async {
    final query = _database.select(_database.wrongQuestions)
      ..where((tbl) =>
          tbl.bankId.equals(bankId) &
          tbl.questionId.equals(questionId) &
          tbl.isMastered.equals(false));

    final result = await query.getSingleOrNull();
    return result != null;
  }

  // ========== 收藏 ==========

  /// 添加收藏
  Future<void> addFavorite(String bankId, String questionId) async {
    final companion = FavoritesCompanion.insert(
      bankId: bankId,
      questionId: questionId,
      createdAt: DateTime.now(),
    );

    await _database.into(_database.favorites).insert(
          companion,
          mode: drift.InsertMode.insertOrIgnore,
        );
  }

  /// 取消收藏
  Future<void> removeFavorite(String bankId, String questionId) async {
    await (_database.delete(_database.favorites)
          ..where((tbl) =>
              tbl.bankId.equals(bankId) & tbl.questionId.equals(questionId)))
        .go();
  }

  /// 获取收藏列表
  Future<List<Favorite>> getFavorites(String bankId) async {
    final query = _database.select(_database.favorites)
      ..where((tbl) => tbl.bankId.equals(bankId))
      ..orderBy([
        (tbl) => drift.OrderingTerm.desc(tbl.createdAt),
      ]);

    return await query.get();
  }

  /// 检查是否已收藏
  Future<bool> isFavorite(String bankId, String questionId) async {
    final query = _database.select(_database.favorites)
      ..where((tbl) =>
          tbl.bankId.equals(bankId) & tbl.questionId.equals(questionId));

    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 切换收藏状态
  Future<bool> toggleFavorite(String bankId, String questionId) async {
    final isFav = await isFavorite(bankId, questionId);
    
    if (isFav) {
      await removeFavorite(bankId, questionId);
      return false;
    } else {
      await addFavorite(bankId, questionId);
      return true;
    }
  }

  // ========== 进度相关 ==========

  /// 获取题库进度
  Future<BankProgressData?> getBankProgress(String bankId) async {
    final query = _database.select(_database.bankProgress)
      ..where((tbl) => tbl.bankId.equals(bankId));

    return await query.getSingleOrNull();
  }

  /// 重置题库进度（清空所有答题记录）
  Future<void> resetBankProgress(String bankId) async {
    // 删除答题记录
    await (_database.delete(_database.answerRecords)
          ..where((tbl) => tbl.bankId.equals(bankId)))
        .go();

    // 重置进度
    await (_database.delete(_database.bankProgress)
          ..where((tbl) => tbl.bankId.equals(bankId)))
        .go();

    // 注意：不删除错题本和收藏
  }
}
