import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/bank_provider.dart';
import '../../../providers/quiz_provider.dart';
import '../../../providers/stats_provider.dart';
import '../../quiz/quiz_page.dart';

/// 题库操作菜单
/// 
/// 显示题库的各种刷题模式和操作选项
class BankOptionsSheet {
  static void show(
    BuildContext context,
    WidgetRef ref,
    String bankId,
    String bankName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                bankName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),

            // 继续刷题
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('继续刷题'),
              subtitle: const Text('按顺序刷题'),
              onTap: () async {
                Navigator.of(context).pop();
                
                final bank = await ref.read(bankByIdProvider(bankId).future);
                
                if (bank != null && context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bankId: bankId,
                        mode: QuizMode.sequential,
                      ),
                    ),
                  );
                }
              },
            ),

            // 错题练习
            ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.orange),
              title: const Text('错题练习'),
              subtitle: const Text('专攻错题'),
              trailing: Consumer(
                builder: (context, ref, child) {
                  final stats = ref.watch(bankStatsProvider(bankId));
                  return stats.maybeWhen(
                    data: (data) => data != null && data.wrongQuestions > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '${data.wrongQuestions}题',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.orange,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              onTap: () async {
                Navigator.of(context).pop();
                
                final bank = await ref.read(bankByIdProvider(bankId).future);
                
                if (bank != null && context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bankId: bankId,
                        mode: QuizMode.wrongQuestions,
                      ),
                    ),
                  );
                }
              },
            ),

            // 收藏练习
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('收藏练习'),
              subtitle: const Text('复习收藏题目'),
              trailing: Consumer(
                builder: (context, ref, child) {
                  final stats = ref.watch(bankStatsProvider(bankId));
                  return stats.maybeWhen(
                    data: (data) => data != null && data.favorites > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '${data.favorites}题',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              onTap: () async {
                Navigator.of(context).pop();
                
                final bank = await ref.read(bankByIdProvider(bankId).future);
                
                if (bank != null && context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bankId: bankId,
                        mode: QuizMode.favorites,
                      ),
                    ),
                  );
                }
              },
            ),

            // 随机练习
            ListTile(
              leading: const Icon(Icons.shuffle, color: Colors.blue),
              title: const Text('随机练习'),
              subtitle: const Text('打乱顺序刷题'),
              onTap: () async {
                Navigator.of(context).pop();
                
                final bank = await ref.read(bankByIdProvider(bankId).future);
                
                if (bank != null && context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bankId: bankId,
                        mode: QuizMode.random,
                      ),
                    ),
                  );
                }
              },
            ),

            const Divider(height: 1),

            // 重置进度
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.red),
              title: const Text('重置进度'),
              subtitle: const Text('清除所有答题记录'),
              onTap: () {
                Navigator.of(context).pop();
                _showResetConfirmDialog(context, ref, bankId, bankName);
              },
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  static void _showResetConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String bankId,
    String bankName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8.w),
            const Text('重置进度'),
          ],
        ),
        content: Text(
          '确定要重置「$bankName」的答题进度吗？\n\n'
          '此操作将清除：\n'
          '• 所有答题记录\n'
          '• 错题本\n'
          '• 收藏题目\n\n'
          '此操作不可恢复！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                // 重置进度
                final notifier = ref.read(bankResetProvider.notifier);
                await notifier.resetBankProgress(bankId);

                // 刷新统计
                ref.invalidate(bankStatsProvider(bankId));
                ref.invalidate(overallStatsProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('「$bankName」进度已重置'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('重置失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('重置', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
