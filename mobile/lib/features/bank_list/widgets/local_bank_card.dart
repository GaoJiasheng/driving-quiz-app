import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/question_bank.dart';
import '../../../providers/stats_provider.dart';
import 'bank_options_sheet.dart';

/// 本地题库卡片
/// 
/// 显示已下载题库的信息和统计数据
class LocalBankCard extends ConsumerWidget {
  final QuestionBank bank;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onWrongQuestions;
  final VoidCallback? onFavorites;

  const LocalBankCard({
    super.key,
    required this.bank,
    required this.onTap,
    required this.onDelete,
    this.onWrongQuestions,
    this.onFavorites,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(bankStatsProvider(bank.id));

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  // 图标
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 标题和题数
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${bank.totalQuestions} 题',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // 更多按钮
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      BankOptionsSheet.show(context, ref, bank.id, bank.name);
                    },
                    tooltip: '更多选项',
                  ),
                  // 删除按钮
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: onDelete,
                    tooltip: '删除',
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // 统计数据
              stats.when(
                data: (statsData) {
                  if (statsData == null) {
                    return _buildEmptyStats(context);
                  }

                  return Column(
                    children: [
                      // 进度条
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: statsData.completionRate,
                          minHeight: 8.h,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(context, statsData.completionRate),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // 统计信息
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatChip(
                            context,
                            icon: Icons.check_circle_outline,
                            label: '已答',
                            value: '${statsData.answeredQuestions}/${statsData.totalQuestions}',
                            color: Colors.blue,
                          ),
                          _buildStatChip(
                            context,
                            icon: Icons.trending_up,
                            label: '正确率',
                            value: '${statsData.accuracy.toStringAsFixed(0)}%',
                            color: Colors.green,
                          ),
                          _buildStatChip(
                            context,
                            icon: Icons.error_outline,
                            label: '错题',
                            value: '${statsData.wrongQuestions}',
                            color: Colors.orange,
                            onTap: onWrongQuestions,
                          ),
                          _buildStatChip(
                            context,
                            icon: Icons.star_outline,
                            label: '收藏',
                            value: '${statsData.favorites}',
                            color: Colors.amber,
                            onTap: onFavorites,
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => _buildEmptyStats(context),
              ),

              SizedBox(height: 12.h),

              // 开始按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('开始刷题'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStats(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        '还没有答题记录，开始刷题吧！',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    final chip = Column(
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        // 可点击提示
        if (onTap != null)
          Container(
            margin: EdgeInsets.only(top: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '点击进入',
              style: TextStyle(
                fontSize: 8.sp,
                color: color,
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: chip,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: chip,
    );
  }

  Color _getProgressColor(BuildContext context, double progress) {
    if (progress >= 0.8) {
      return Colors.green;
    } else if (progress >= 0.5) {
      return Colors.blue;
    } else if (progress >= 0.2) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }
}
