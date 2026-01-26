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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createIndices();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // 升级到版本2：添加性能索引
          await _createIndices();
        }
      },
    );
  }

  /// 创建性能优化索引
  Future<void> _createIndices() async {
    // 为answer_records表添加索引
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_answer_records_bank_id 
      ON answer_records(bank_id);
    ''');
    
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_answer_records_question_id 
      ON answer_records(question_id);
    ''');
    
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_answer_records_answered_at 
      ON answer_records(answered_at DESC);
    ''');

    // 为wrong_questions表添加索引
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_wrong_questions_bank_id 
      ON wrong_questions(bank_id);
    ''');
    
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_wrong_questions_mastered 
      ON wrong_questions(is_mastered);
    ''');

    // 为favorites表添加索引
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_favorites_bank_id 
      ON favorites(bank_id);
    ''');
    
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_favorites_created_at 
      ON favorites(created_at DESC);
    ''');
  }

  /// 打开数据库连接
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'quiz_app.db'));
      
      // 性能优化：配置SQLite参数
      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          // 启用WAL模式（提升并发性能）
          rawDb.execute('PRAGMA journal_mode = WAL;');
          // 增加缓存大小
          rawDb.execute('PRAGMA cache_size = 2000;');
          // 优化同步模式（平衡性能和安全）
          rawDb.execute('PRAGMA synchronous = NORMAL;');
          // 优化临时存储（使用内存）
          rawDb.execute('PRAGMA temp_store = MEMORY;');
        },
      );
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
