import 'package:drift/drift.dart';

/// 答题记录表
/// 
/// 存储用户的答题历史
class AnswerRecords extends Table {
  /// 记录ID（自增主键）
  IntColumn get id => integer().autoIncrement()();
  
  /// 题库ID
  TextColumn get bankId => text()();
  
  /// 题目ID
  TextColumn get questionId => text()();
  
  /// 用户答案（JSON数组，如 [0,1] 表示选择了A和B）
  TextColumn get userAnswer => text().nullable()();
  
  /// 是否正确
  BoolColumn get isCorrect => boolean()();
  
  /// 答题时间
  DateTimeColumn get answeredAt => dateTime()();
  
  /// 创建索引以提高查询效率
  @override
  List<Set<Column>> get uniqueKeys => [
    {bankId, questionId}
  ];
}
