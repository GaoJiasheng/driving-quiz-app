import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/quiz_provider.dart';

/// 答题卡抽屉
/// 
/// 显示所有题目的答题状态，可快速跳转
class QuizDrawer extends ConsumerWidget {
  const QuizDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // 标题
            Container(
              padding: EdgeInsets.all(16.w),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '答题卡',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 统计信息
            Container(
              padding: EdgeInsets.all(16.w),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    label: '总题数',
                    value: '${quizState.allQuestions.length}',
                    color: Colors.blue,
                  ),
                  _buildStatItem(
                    context,
                    label: '已答',
                    value: '${quizState.answeredCount}',
                    color: Colors.green,
                  ),
                  _buildStatItem(
                    context,
                    label: '错题',
                    value: '${quizState.wrongQuestionIds.length}',
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            // 图例
            Container(
              padding: EdgeInsets.all(16.w),
              child: Wrap(
                spacing: 16.w,
                runSpacing: 8.h,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  _buildLegend(context, '当前', Colors.blue),
                  _buildLegend(context, '已答', Colors.green),
                  _buildLegend(context, '未答', Colors.grey.shade300),
                  if (quizState.wrongQuestionIds.isNotEmpty)
                    _buildLegend(context, '错题', Colors.red),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade300),

            // 题目网格（显示全部题目）
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1,
                ),
                itemCount: quizState.allQuestions.length,
                itemBuilder: (context, index) {
                  final question = quizState.allQuestions[index];
                  final currentQuestionId = quizState.currentQuestion?.id;
                  final isCurrent = question.id == currentQuestionId;
                  final hasAnswered =
                      quizState.userAnswers.containsKey(question.id);
                  final isWrongQuestion =
                      quizState.wrongQuestionIds.contains(question.id);
                  // 检查这道题是否在当前过滤列表中（可跳转）
                  final isInFilteredList = quizState.questions.any((q) => q.id == question.id);

                  Color backgroundColor;
                  Color textColor;
                  Color? borderColor;
                  double opacity = 1.0;

                  if (isCurrent) {
                    backgroundColor = Colors.blue;
                    textColor = Colors.white;
                    borderColor = isWrongQuestion ? Colors.red : null;
                  } else if (isWrongQuestion) {
                    // 错题标记为红色
                    backgroundColor = Colors.red;
                    textColor = Colors.white;
                  } else if (hasAnswered) {
                    backgroundColor = Colors.green;
                    textColor = Colors.white;
                  } else {
                    backgroundColor = Colors.grey.shade300;
                    textColor = Colors.black87;
                  }

                  // 不在过滤列表中的题目（不可跳转）
                  if (!isInFilteredList) {
                    opacity = 0.3;
                  }

                  return InkWell(
                    onTap: isInFilteredList ? () {
                      // 找到这个题目在当前questions列表中的索引
                      final targetIndex = quizState.questions.indexWhere((q) => q.id == question.id);
                      if (targetIndex >= 0) {
                        ref.read(quizProvider.notifier).goToQuestion(targetIndex);
                        Navigator.of(context).pop();
                      }
                    } : null,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: borderColor != null
                              ? Border.all(color: borderColor, width: 3)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
