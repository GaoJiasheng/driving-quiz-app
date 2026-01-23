import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'question.dart';

part 'question_bank.g.dart';

/// 题库模型
@JsonSerializable()
class QuestionBank extends Equatable {
  /// 题库ID
  final String id;

  /// 题库名称
  final String name;

  /// 版本号
  final String version;

  /// 描述
  final String? description;

  /// 题目总数
  @JsonKey(name: 'total_questions')
  final int totalQuestions;

  /// 创建时间
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  /// 语言
  final String language;

  /// 题目列表
  final List<Question>? questions;

  const QuestionBank({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    required this.totalQuestions,
    this.createdAt,
    this.updatedAt,
    required this.language,
    this.questions,
  });

  /// 从JSON创建
  factory QuestionBank.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankFromJson(json);

  /// 转为JSON
  Map<String, dynamic> toJson() => _$QuestionBankToJson(this);

  /// 复制并修改
  QuestionBank copyWith({
    String? id,
    String? name,
    String? version,
    String? description,
    int? totalQuestions,
    String? createdAt,
    String? updatedAt,
    String? language,
    List<Question>? questions,
  }) {
    return QuestionBank(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      description: description ?? this.description,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      language: language ?? this.language,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        version,
        description,
        totalQuestions,
        createdAt,
        updatedAt,
        language,
        questions,
      ];
}

/// 题库信息（用于列表展示，不包含完整题目）
@JsonSerializable()
class QuestionBankInfo extends Equatable {
  final String id;
  final String name;
  final String? description;

  @JsonKey(name: 'total_questions')
  final int totalQuestions;

  final String version;
  final String language;

  @JsonKey(name: 'size')
  final int? sizeBytes;

  @JsonKey(name: 'download_url')
  final String? downloadUrl;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const QuestionBankInfo({
    required this.id,
    required this.name,
    this.description,
    required this.totalQuestions,
    required this.version,
    required this.language,
    this.sizeBytes,
    this.downloadUrl,
    this.updatedAt,
  });

  factory QuestionBankInfo.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBankInfoToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        totalQuestions,
        version,
        language,
        sizeBytes,
        downloadUrl,
        updatedAt,
      ];
}
