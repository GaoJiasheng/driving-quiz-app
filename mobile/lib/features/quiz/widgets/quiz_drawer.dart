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
                    value: '${quizState.totalQuestions}',
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
                    label: '未答',
                    value: '${quizState.totalQuestions - quizState.answeredCount}',
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // 图例
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegend(context, '当前', Colors.blue),
                  _buildLegend(context, '已答', Colors.green),
                  _buildLegend(context, '未答', Colors.grey.shade300),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade300),

            // 题目网格
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1,
                ),
                itemCount: quizState.totalQuestions,
                itemBuilder: (context, index) {
                  final question = quizState.questions[index];
                  final isCurrent = index == quizState.currentIndex;
                  final hasAnswered =
                      quizState.userAnswers.containsKey(question.id);

                  Color backgroundColor;
                  Color textColor;

                  if (isCurrent) {
                    backgroundColor = Colors.blue;
                    textColor = Colors.white;
                  } else if (hasAnswered) {
                    backgroundColor = Colors.green;
                    textColor = Colors.white;
                  } else {
                    backgroundColor = Colors.grey.shade300;
                    textColor = Colors.black87;
                  }

                  return InkWell(
                    onTap: () {
                      ref.read(quizProvider.notifier).goToQuestion(index);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
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
