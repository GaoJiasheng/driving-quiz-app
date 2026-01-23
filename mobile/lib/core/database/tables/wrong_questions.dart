import 'package:drift/drift.dart';

/// 错题表
/// 
/// 记录用户做错的题目
class WrongQuestions extends Table {
  /// 记录ID（自增主键）
  IntColumn get id => integer().autoIncrement()();
  
  /// 题库ID
  TextColumn get bankId => text()();
  
  /// 题目ID
  TextColumn get questionId => text()();
  
  /// 是否已掌握
  BoolColumn get isMastered => boolean().withDefault(const Constant(false))();
  
  /// 加入错题本的时间
  DateTimeColumn get addedAt => dateTime()();
  
  /// 唯一约束：同一题库的同一题目只能有一条记录
  @override
  List<Set<Column>> get uniqueKeys => [
    {bankId, questionId}
  ];
}
