import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/quiz_provider.dart';

/// 刷题底部操作栏
/// 
/// 包含上一题、下一题、显示答案等操作
class QuizBottomBar extends ConsumerWidget {
  const QuizBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final hasAnswered = quizState.hasAnswered;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 上一题按钮
            Expanded(
              child: OutlinedButton.icon(
                onPressed: quizState.isFirstQuestion
                    ? null
                    : () {
                        ref.read(quizProvider.notifier).previousQuestion();
                      },
                icon: const Icon(Icons.arrow_back),
                label: const Text('上一题'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // 显示/隐藏答案按钮（仅已答题时显示）
            if (hasAnswered) ...[
              OutlinedButton(
                onPressed: () {
                  ref.read(quizProvider.notifier).toggleShowAnswer();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                child: Icon(
                  quizState.showAnswer
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              SizedBox(width: 12.w),
            ],

            // 下一题按钮
            Expanded(
              child: ElevatedButton.icon(
                onPressed: quizState.isLastQuestion
                    ? null
                    : () {
                        ref.read(quizProvider.notifier).nextQuestion();
                      },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('下一题'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
