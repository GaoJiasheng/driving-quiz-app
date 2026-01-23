import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// 导入所有表定义
import 'tables/question_banks.dart';
import 'tables/answer_records.dart';
import 'tables/bank_progress.dart';
import 'tables/wrong_questions.dart';
import 'tables/favorites.dart';

part 'database.g.dart';

/// 应用数据库
/// 
/// 包含5张表：
/// - question_banks: 题库数据
/// - answer_records: 答题记录
/// - bank_progress: 题库进度
/// - wrong_questions: 错题本
/// - favorites: 收藏夹
@DriftDatabase(tables: [
  QuestionBanks,
  AnswerRecords,
  BankProgress,
  WrongQuestions,
  Favorites,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 打开数据库连接
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'quiz_app.db'));
      return NativeDatabase(file);
    });
  }

  /// 删除数据库（用于开发测试）
  static Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'quiz_app.db'));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
