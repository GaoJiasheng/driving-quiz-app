import 'package:drift/drift.dart';

/// 收藏表
/// 
/// 记录用户收藏的题目
class Favorites extends Table {
  /// 记录ID（自增主键）
  IntColumn get id => integer().autoIncrement()();
  
  /// 题库ID
  TextColumn get bankId => text()();
  
  /// 题目ID
  TextColumn get questionId => text()();
  
  /// 收藏时间
  DateTimeColumn get createdAt => dateTime()();
  
  /// 唯一约束：同一题库的同一题目只能收藏一次
  @override
  List<Set<Column>> get uniqueKeys => [
    {bankId, questionId}
  ];
}
