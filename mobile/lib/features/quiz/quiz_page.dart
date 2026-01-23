import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/quiz_provider.dart';
import '../../providers/bank_provider.dart';
import 'widgets/question_card.dart';
import 'widgets/quiz_bottom_bar.dart';
import 'widgets/quiz_drawer.dart';

/// 刷题页面
/// 
/// 核心刷题功能页面
class QuizPage extends ConsumerStatefulWidget {
  final String bankId;
  final QuizMode mode;

  const QuizPage({
    super.key,
    required this.bankId,
    this.mode = QuizMode.sequential,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 在下一帧初始化刷题
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQuiz();
    });
  }

  Future<void> _initializeQuiz() async {
    if (_isInitialized) return;

    // 获取题库
    final bank = await ref.read(bankByIdProvider(widget.bankId).future);

    if (bank != null && mounted) {
      // 开始刷题
      final quizNotifier = ref.read(quizProvider.notifier);
      await quizNotifier.startQuiz(bank, mode: widget.mode);
      setState(() => _isInitialized = true);
    } else if (mounted) {
      // 题库不存在，返回
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('题库不存在')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    // 加载中
    if (quizState.isLoading || !_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('加载中...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 错误
    if (quizState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('错误')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: 16.h),
              Text(quizState.error!),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }

    // 没有题目
    if (quizState.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('提示')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz,
                size: 64.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                _getEmptyMessage(widget.mode),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            quizState.bank?.name ?? '刷题',
            style: const TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            // 答题卡按钮
            IconButton(
              icon: const Icon(Icons.grid_view),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              tooltip: '答题卡',
            ),
          ],
        ),
        endDrawer: const QuizDrawer(),
        body: Column(
          children: [
            // 进度条
            _buildProgressBar(quizState),

            // 题目卡片
            Expanded(
              child: PageView.builder(
                itemCount: quizState.totalQuestions,
                controller: PageController(
                  initialPage: quizState.currentIndex,
                ),
                onPageChanged: (index) {
                  ref.read(quizProvider.notifier).goToQuestion(index);
                },
                itemBuilder: (context, index) {
                  return QuestionCard(
                    question: quizState.questions[index],
                    questionNumber: index + 1,
                    totalQuestions: quizState.totalQuestions,
                  );
                },
              ),
            ),

            // 底部操作栏
            const QuizBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(QuizState quizState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '进度: ${quizState.currentIndex + 1}/${quizState.totalQuestions}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '已答: ${quizState.answeredCount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: (quizState.currentIndex + 1) / quizState.totalQuestions,
              minHeight: 4.h,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyMessage(QuizMode mode) {
    switch (mode) {
      case QuizMode.wrongQuestions:
        return '暂无错题\n继续努力！';
      case QuizMode.favorites:
        return '暂无收藏题目\n先去收藏一些题目吧';
      default:
        return '该题库暂无题目';
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出刷题'),
        content: const Text('确定要退出吗？当前进度会保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('继续刷题'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('退出'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 重置刷题状态
      ref.read(quizProvider.notifier).reset();
    }

    return confirmed ?? false;
  }
}
