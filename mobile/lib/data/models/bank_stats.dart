import 'package:equatable/equatable.dart';

/// 题库统计信息
class BankStats extends Equatable {
  /// 题库ID
  final String bankId;

  /// 题库名称
  final String bankName;

  /// 题目总数
  final int totalQuestions;

  /// 已答题数
  final int answeredCount;

  /// 答对题数
  final int correctCount;

  /// 答错题数
  final int wrongCount;

  /// 错题本题数（未掌握的）
  final int wrongQuestionsCount;

  /// 收藏题数
  final int favoritesCount;

  const BankStats({
    required this.bankId,
    required this.bankName,
    required this.totalQuestions,
    required this.answeredCount,
    required this.correctCount,
    required this.wrongCount,
    required this.wrongQuestionsCount,
    required this.favoritesCount,
  });

  /// 正确率（百分比）
  double get accuracy {
    if (answeredCount == 0) return 0.0;
    return (correctCount / answeredCount * 100);
  }

  /// 进度百分比
  double get progress {
    if (totalQuestions == 0) return 0.0;
    return (answeredCount / totalQuestions * 100);
  }

  /// 完成率（别名，用于兼容）
  double get completionRate => progress;

  /// 正确答案数（别名，用于兼容）
  int get correctAnswers => correctCount;

  /// 错题数（别名，用于兼容）
  int get wrongQuestions => wrongQuestionsCount;

  /// 收藏数（别名，用于兼容）
  int get favorites => favoritesCount;

  /// 已答题数（别名，用于兼容）
  int get answeredQuestions => answeredCount;

  /// 未答题数
  int get unansweredCount => totalQuestions - answeredCount;

  @override
  List<Object?> get props => [
        bankId,
        bankName,
        totalQuestions,
        answeredCount,
        correctCount,
        wrongCount,
        wrongQuestionsCount,
        favoritesCount,
      ];
}
