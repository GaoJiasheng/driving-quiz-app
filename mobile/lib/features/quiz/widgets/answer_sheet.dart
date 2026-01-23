import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/question.dart';

/// 答案解析组件
/// 
/// 显示正确答案和解析说明
class AnswerSheet extends StatelessWidget {
  final Question question;
  final List<int> userAnswer;

  const AnswerSheet({
    super.key,
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    // 判断是否答对
    final userAnswerSorted = List<int>.from(userAnswer)..sort();
    final correctAnswerSorted = List<int>.from(question.answer)..sort();
    final isCorrect = userAnswerSorted.length == correctAnswerSorted.length &&
        userAnswerSorted.every((e) => correctAnswerSorted.contains(e));

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.05)
            : Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 答题结果
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                isCorrect ? '回答正确！' : '回答错误',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // 正确答案
          _buildAnswerRow(
            context,
            label: '正确答案',
            answer: question.answer
                .map((i) => String.fromCharCode(65 + i))
                .join(', '),
            color: Colors.green,
          ),

          // 你的答案（如果答错）
          if (!isCorrect) ...[
            SizedBox(height: 8.h),
            _buildAnswerRow(
              context,
              label: '你的答案',
              answer: userAnswer.isEmpty
                  ? '未作答'
                  : userAnswer
                      .map((i) => String.fromCharCode(65 + i))
                      .join(', '),
              color: Colors.red,
            ),
          ],

          // 解析
          if (question.explanation != null) ...[
            SizedBox(height: 12.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '解析',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        question.explanation!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerRow(
    BuildContext context, {
    required String label,
    required String answer,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          answer,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
