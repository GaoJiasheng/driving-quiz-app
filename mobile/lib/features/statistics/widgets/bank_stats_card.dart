import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/bank_stats.dart';

/// 题库统计卡片
/// 
/// 显示单个题库的详细统计信息
class BankStatsCard extends StatelessWidget {
  final String bankId;
  final String bankName;
  final BankStats stats;
  final VoidCallback onTap;

  const BankStatsCard({
    super.key,
    required this.bankId,
    required this.bankName,
    required this.stats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
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
                  // 题库图标
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.book,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 题库名称和进度
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${stats.answeredQuestions}/${stats.totalQuestions} 题',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // 成绩标签
                  _buildGradeBadge(context),
                ],
              ),

              SizedBox(height: 12.h),

              // 进度条
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '完成进度',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${(stats.completionRate * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getProgressColor(stats.completionRate),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: stats.completionRate,
                      minHeight: 8.h,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(stats.completionRate),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // 统计数据
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(
                    context,
                    icon: Icons.check_circle,
                    label: '正确',
                    value: '${stats.correctAnswers}',
                    color: Colors.green,
                  ),
                  _buildStatChip(
                    context,
                    icon: Icons.trending_up,
                    label: '正确率',
                    value: '${(stats.accuracy * 100).toStringAsFixed(0)}%',
                    color: Colors.blue,
                  ),
                  _buildStatChip(
                    context,
                    icon: Icons.error_outline,
                    label: '错题',
                    value: '${stats.wrongQuestions}',
                    color: Colors.orange,
                  ),
                  _buildStatChip(
                    context,
                    icon: Icons.star,
                    label: '收藏',
                    value: '${stats.favorites}',
                    color: Colors.amber,
                  ),
                ],
              ),

              // 操作提示
              if (stats.wrongQuestions > 0 || stats.favorites > 0) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _getTipText(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
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
      ],
    );
  }

  Widget _buildGradeBadge(BuildContext context) {
    final accuracy = stats.accuracy;
    String grade;
    Color color;

    if (accuracy >= 0.9) {
      grade = 'A+';
      color = Colors.green;
    } else if (accuracy >= 0.8) {
      grade = 'A';
      color = Colors.lightGreen;
    } else if (accuracy >= 0.7) {
      grade = 'B';
      color = Colors.blue;
    } else if (accuracy >= 0.6) {
      grade = 'C';
      color = Colors.orange;
    } else {
      grade = 'D';
      color = Colors.red;
    }

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          grade,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
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

  String _getTipText() {
    if (stats.wrongQuestions > 5) {
      return '有 ${stats.wrongQuestions} 道错题，建议复习巩固';
    } else if (stats.favorites > 0) {
      return '有 ${stats.favorites} 道收藏题目，可以专项练习';
    } else {
      return '点击查看更多练习选项';
    }
  }
}
