import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

/// 题目类型枚举
enum QuestionType {
  /// 单选题
  single,
  /// 多选题
  multiple,
  /// 判断题
  judge,
}

/// 题目模型
@JsonSerializable()
class Question extends Equatable {
  /// 题目ID
  final String id;

  /// 题目类型：single-单选，multiple-多选，judge-判断
  final String type;

  /// 题目内容
  final String question;

  /// 题目图片URL（可选）
  final String? image;

  /// 选项列表
  final List<String> options;

  /// 正确答案（索引数组，如 [0] 或 [0,2]）
  final List<int> answer;

  /// 题目解析
  final String? explanation;

  /// 所属章节（可选）
  final String? chapter;

  const Question({
    required this.id,
    required this.type,
    required this.question,
    this.image,
    required this.options,
    required this.answer,
    this.explanation,
    this.chapter,
  });

  /// 从JSON创建
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /// 转为JSON
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  /// 判断是否为单选题
  bool get isSingle => type == 'single';

  /// 判断是否为多选题
  bool get isMultiple => type == 'multiple';

  /// 判断是否为判断题
  bool get isJudge => type == 'judge';

  /// 获取题目类型枚举
  QuestionType get questionType {
    switch (type) {
      case 'single':
        return QuestionType.single;
      case 'multiple':
        return QuestionType.multiple;
      case 'judge':
        return QuestionType.judge;
      default:
        return QuestionType.single;
    }
  }

  /// 获取题目类型中文名称
  String get typeLabel {
    switch (type) {
      case 'single':
        return '单选题';
      case 'multiple':
        return '多选题';
      case 'judge':
        return '判断题';
      default:
        return '未知';
    }
  }

  /// 判断用户答案是否正确
  bool isAnswerCorrect(List<int> userAnswer) {
    if (userAnswer.length != answer.length) return false;
    
    final sortedUser = List<int>.from(userAnswer)..sort();
    final sortedCorrect = List<int>.from(answer)..sort();
    
    for (int i = 0; i < sortedUser.length; i++) {
      if (sortedUser[i] != sortedCorrect[i]) return false;
    }
    
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        question,
        image,
        options,
        answer,
        explanation,
        chapter,
      ];
}
