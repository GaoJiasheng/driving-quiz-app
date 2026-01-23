import 'package:drift/drift.dart';

/// 题库进度表
/// 
/// 记录每个题库的刷题进度
class BankProgress extends Table {
  /// 题库ID（主键）
  TextColumn get bankId => text()();
  
  /// 顺序模式：当前题目索引
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  
  /// 已答题总数
  IntColumn get totalAnswered => integer().withDefault(const Constant(0))();
  
  /// 答对题数
  IntColumn get totalCorrect => integer().withDefault(const Constant(0))();
  
  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {bankId};
}
