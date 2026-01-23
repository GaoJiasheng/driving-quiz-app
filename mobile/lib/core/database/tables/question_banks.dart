import 'package:drift/drift.dart';

/// 题库表
/// 
/// 存储下载的题库数据
class QuestionBanks extends Table {
  /// 题库ID（主键）
  TextColumn get id => text()();
  
  /// 题库名称
  TextColumn get name => text()();
  
  /// 版本号
  TextColumn get version => text()();
  
  /// 题目总数
  IntColumn get totalQuestions => integer()();
  
  /// 语言
  TextColumn get language => text()();
  
  /// 下载时间
  DateTimeColumn get downloadedAt => dateTime()();
  
  /// 题库数据（JSON格式存储完整题目）
  TextColumn get data => text()();
  
  @override
  Set<Column> get primaryKey => {id};
}
