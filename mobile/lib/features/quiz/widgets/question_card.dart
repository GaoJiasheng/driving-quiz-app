import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/question.dart';
import '../../../providers/quiz_provider.dart';
import 'option_item.dart';
import 'answer_sheet.dart';

/// 题目卡片
/// 
/// 显示题目内容、选项和答案解析
class QuestionCard extends ConsumerStatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  ConsumerState<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard> {
  final Set<int> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _loadUserAnswer();
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _loadUserAnswer();
    }
  }

  void _loadUserAnswer() {
    final quizState = ref.read(quizProvider);
    final userAnswer = quizState.userAnswers[widget.question.id];
    
    setState(() {
      _selectedOptions.clear();
      if (userAnswer != null) {
        _selectedOptions.addAll(userAnswer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final hasAnswered = quizState.userAnswers.containsKey(widget.question.id);
    final showAnswer = quizState.showAnswer && hasAnswered;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题目类型和题号
          Row(
            children: [
              _buildTypeChip(widget.question.questionType),
              SizedBox(width: 8.w),
              Text(
                '第 ${widget.questionNumber} 题',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              // 收藏按钮
              _buildFavoriteButton(),
              // 移除错题按钮（仅在错题模式显示）
              if (ref.watch(quizProvider).mode == QuizMode.wrongQuestions)
                _buildMasteredButton(),
            ],
          ),

          SizedBox(height: 16.h),

          // 题目内容
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              widget.question.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),

          SizedBox(height: 16.h),

          // 选项列表
          ...List.generate(
            widget.question.options.length,
            (index) => OptionItem(
              option: widget.question.options[index],
              optionIndex: index,
              isSelected: _selectedOptions.contains(index),
              isCorrect: showAnswer
                  ? widget.question.answer.contains(index)
                  : null,
              isWrong: showAnswer &&
                  _selectedOptions.contains(index) &&
                  !widget.question.answer.contains(index),
              onTap: hasAnswered
                  ? null
                  : () => _onOptionTap(index, widget.question.questionType),
            ),
          ),

          SizedBox(height: 16.h),

          // 提交按钮（仅多选题未答题时显示）
          if (!hasAnswered && 
              _selectedOptions.isNotEmpty && 
              widget.question.questionType == QuestionType.multiple)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitAnswer(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: const Text('提交答案'),
              ),
            ),

          // 答案解析（已答题时显示）
          if (showAnswer) ...[
            SizedBox(height: 8.h),
            AnswerSheet(
              question: widget.question,
              userAnswer: _selectedOptions.toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeChip(QuestionType type) {
    String label;
    Color color;

    switch (type) {
      case QuestionType.single:
        label = '单选题';
        color = Colors.blue;
        break;
      case QuestionType.multiple:
        label = '多选题';
        color = Colors.orange;
        break;
      case QuestionType.judge:
        label = '判断题';
        color = Colors.green;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    final isFavorite = ref.watch(isCurrentQuestionFavoriteProvider);

    return isFavorite.when(
      data: (favorite) => IconButton(
        icon: Icon(
          favorite ? Icons.star : Icons.star_outline,
          color: favorite ? Colors.amber : null,
        ),
        onPressed: () async {
          final notifier = ref.read(quizProvider.notifier);
          await notifier.toggleFavorite();
          ref.invalidate(isCurrentQuestionFavoriteProvider);
        },
        tooltip: favorite ? '取消收藏' : '收藏',
      ),
      loading: () => const SizedBox(
        width: 48,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const SizedBox(width: 48),
    );
  }

  void _onOptionTap(int index, QuestionType type) {
    setState(() {
      if (type == QuestionType.single || type == QuestionType.judge) {
        // 单选题和判断题：只能选一个
        _selectedOptions.clear();
        _selectedOptions.add(index);
      } else {
        // 多选题：可以选多个
        if (_selectedOptions.contains(index)) {
          _selectedOptions.remove(index);
        } else {
          _selectedOptions.add(index);
        }
      }
    });

    // 单选题和判断题：选择后立即提交
    if (type == QuestionType.single || type == QuestionType.judge) {
      _submitAnswer();
    }
  }

  Future<void> _submitAnswer() async {
    if (_selectedOptions.isEmpty) return;

    final quizNotifier = ref.read(quizProvider.notifier);
    await quizNotifier.submitAnswer(_selectedOptions.toList()..sort());

    // 提交后显示答案
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildMasteredButton() {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.error,
      ),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('移除错题'),
            content: const Text('确定要将此题移出错题本吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('移除'),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          final notifier = ref.read(quizProvider.notifier);
          await notifier.markAsMastered();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('已从错题本移除')),
            );
            // 不需要手动跳到下一题，因为列表更新后，当前索引对应的就是下一题
          }
        }
      },
      tooltip: '移除错题',
    );
  }
}
