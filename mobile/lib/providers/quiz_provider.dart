import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question.dart';
import '../data/models/question_bank.dart';
import '../data/repositories/answer_repository.dart';
import 'database_provider.dart';
import 'bank_provider.dart';

/// 刷题模式
enum QuizMode {
  /// 顺序模式
  sequential,
  
  /// 随机模式
  random,
  
  /// 错题模式
  wrongQuestions,
  
  /// 收藏模式
  favorites,
}

/// 刷题状态
class QuizState {
  /// 当前题库
  final QuestionBank? bank;
  
  /// 题目列表（根据模式过滤后的）
  final List<Question> questions;
  
  /// 当前题目索引
  final int currentIndex;
  
  /// 用户答案（题目ID -> 用户选择的选项索引列表）
  final Map<String, List<int>> userAnswers;
  
  /// 是否显示答案
  final bool showAnswer;
  
  /// 刷题模式
  final QuizMode mode;
  
  /// 是否正在加载
  final bool isLoading;
  
  /// 错误信息
  final String? error;

  QuizState({
    this.bank,
    this.questions = const [],
    this.currentIndex = 0,
    this.userAnswers = const {},
    this.showAnswer = false,
    this.mode = QuizMode.sequential,
    this.isLoading = false,
    this.error,
  });

  /// 当前题目
  Question? get currentQuestion {
    if (currentIndex >= 0 && currentIndex < questions.length) {
      return questions[currentIndex];
    }
    return null;
  }

  /// 当前题目的用户答案
  List<int>? get currentUserAnswer {
    final question = currentQuestion;
    if (question == null) return null;
    return userAnswers[question.id];
  }

  /// 是否已答题
  bool get hasAnswered => currentUserAnswer != null;

  /// 当前题是否答对
  bool? get isCurrentCorrect {
    final question = currentQuestion;
    final answer = currentUserAnswer;
    
    if (question == null || answer == null) return null;
    
    // 比较答案（需要排序后比较）
    final userAnswerSorted = List<int>.from(answer)..sort();
    final correctAnswerSorted = List<int>.from(question.answer)..sort();
    
    return userAnswerSorted.length == correctAnswerSorted.length &&
        userAnswerSorted.every((e) => correctAnswerSorted.contains(e));
  }

  /// 总题数
  int get totalQuestions => questions.length;

  /// 已答题数
  int get answeredCount => userAnswers.length;

  /// 进度百分比
  double get progress => totalQuestions > 0 ? answeredCount / totalQuestions : 0.0;

  /// 是否是最后一题
  bool get isLastQuestion => currentIndex >= totalQuestions - 1;

  /// 是否是第一题
  bool get isFirstQuestion => currentIndex <= 0;

  QuizState copyWith({
    QuestionBank? bank,
    List<Question>? questions,
    int? currentIndex,
    Map<String, List<int>>? userAnswers,
    bool? showAnswer,
    QuizMode? mode,
    bool? isLoading,
    String? error,
  }) {
    return QuizState(
      bank: bank ?? this.bank,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      showAnswer: showAnswer ?? this.showAnswer,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 刷题状态管理器
class QuizNotifier extends StateNotifier<QuizState> {
  final AnswerRepository _answerRepository;

  QuizNotifier(this._answerRepository) : super(QuizState());

  /// 开始刷题
  /// 
  /// [bank] 题库
  /// [mode] 刷题模式
  Future<void> startQuiz(QuestionBank bank, {QuizMode mode = QuizMode.sequential}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      List<Question> questions = bank.questions ?? [];

      // 根据模式过滤题目
      switch (mode) {
        case QuizMode.sequential:
          // 顺序模式，保持原样
          break;

        case QuizMode.random:
          // 随机模式，打乱顺序
          questions = List<Question>.from(questions)..shuffle();
          break;

        case QuizMode.wrongQuestions:
          // 错题模式，只显示错题本中的题目
          final wrongQuestions = await _answerRepository.getWrongQuestions(bank.id);
          final wrongQuestionIds = wrongQuestions.map((e) => e.questionId).toSet();
          questions = questions.where((q) => wrongQuestionIds.contains(q.id)).toList();
          break;

        case QuizMode.favorites:
          // 收藏模式，只显示收藏的题目
          final favorites = await _answerRepository.getFavorites(bank.id);
          final favoriteIds = favorites.map((e) => e.questionId).toSet();
          questions = questions.where((q) => favoriteIds.contains(q.id)).toList();
          break;
      }

      state = QuizState(
        bank: bank,
        questions: questions,
        currentIndex: 0,
        mode: mode,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 提交答案
  /// 
  /// [selectedOptions] 用户选择的选项索引列表
  Future<void> submitAnswer(List<int> selectedOptions) async {
    final question = state.currentQuestion;
    final bank = state.bank;
    
    if (question == null || bank == null) return;

    // 判断是否正确
    final userAnswerSorted = List<int>.from(selectedOptions)..sort();
    final correctAnswerSorted = List<int>.from(question.answer)..sort();
    final isCorrect = userAnswerSorted.length == correctAnswerSorted.length &&
        userAnswerSorted.every((e) => correctAnswerSorted.contains(e));

    // 保存答题记录
    await _answerRepository.saveAnswerRecord(
      bankId: bank.id,
      questionId: question.id,
      userAnswer: selectedOptions,
      isCorrect: isCorrect,
    );

    // 更新状态
    final newAnswers = Map<String, List<int>>.from(state.userAnswers);
    newAnswers[question.id] = selectedOptions;

    state = state.copyWith(
      userAnswers: newAnswers,
      showAnswer: true,
    );
  }

  /// 下一题
  void nextQuestion() {
    if (!state.isLastQuestion) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        showAnswer: false,
      );
    }
  }

  /// 上一题
  void previousQuestion() {
    if (!state.isFirstQuestion) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        showAnswer: false,
      );
    }
  }

  /// 跳转到指定题目
  void goToQuestion(int index) {
    if (index >= 0 && index < state.totalQuestions) {
      state = state.copyWith(
        currentIndex: index,
        showAnswer: false,
      );
    }
  }

  /// 切换显示答案
  void toggleShowAnswer() {
    state = state.copyWith(showAnswer: !state.showAnswer);
  }

  /// 重置刷题状态
  void reset() {
    state = QuizState();
  }

  /// 收藏/取消收藏当前题目
  Future<bool> toggleFavorite() async {
    final question = state.currentQuestion;
    final bank = state.bank;
    
    if (question == null || bank == null) return false;

    return await _answerRepository.toggleFavorite(bank.id, question.id);
  }

  /// 检查当前题目是否已收藏
  Future<bool> isCurrentFavorite() async {
    final question = state.currentQuestion;
    final bank = state.bank;
    
    if (question == null || bank == null) return false;

    return await _answerRepository.isFavorite(bank.id, question.id);
  }

  /// 标记错题为已掌握
  Future<void> markAsMastered() async {
    final question = state.currentQuestion;
    final bank = state.bank;
    
    if (question == null || bank == null) return;

    await _answerRepository.markWrongQuestionAsMastered(bank.id, question.id);
  }
}

/// 刷题状态Provider
final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final answerRepository = ref.watch(answerRepositoryProvider);
  return QuizNotifier(answerRepository);
});

/// 当前题目是否已收藏Provider
final isCurrentQuestionFavoriteProvider = FutureProvider<bool>((ref) async {
  final quizState = ref.watch(quizProvider);
  final question = quizState.currentQuestion;
  final bank = quizState.bank;
  
  if (question == null || bank == null) return false;

  final answerRepository = ref.watch(answerRepositoryProvider);
  return await answerRepository.isFavorite(bank.id, question.id);
});

/// 当前题目是否在错题本中Provider
final isCurrentQuestionWrongProvider = FutureProvider<bool>((ref) async {
  final quizState = ref.watch(quizProvider);
  final question = quizState.currentQuestion;
  final bank = quizState.bank;
  
  if (question == null || bank == null) return false;

  final answerRepository = ref.watch(answerRepositoryProvider);
  return await answerRepository.isInWrongQuestions(bank.id, question.id);
});
