import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/stats_provider.dart';

/// 总体统计卡片
/// 
/// 显示整体学习数据和成就
class OverallStatsCard extends StatelessWidget {
  final OverallStats stats;

  const OverallStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题和成就徽章
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '学习总览',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _getMotivationalText(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAchievementBadge(context),
              ],
            ),
          ),

          // 主要统计数据
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              children: [
                // 第一行：题库和题目
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.collections_bookmark,
                        label: '题库总数',
                        value: '${stats.totalBanks}',
                        subtitle: '已完成 ${stats.completedBanks}',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.quiz,
                        label: '题目总数',
                        value: '${stats.totalQuestions}',
                        subtitle: '已答 ${stats.answeredQuestions}',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // 第二行：正确率和完成度
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.trending_up,
                        label: '总体正确率',
                        value: '${(stats.overallAccuracy * 100).toStringAsFixed(1)}%',
                        subtitle: '${stats.correctAnswers}/${stats.answeredQuestions}',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.check_circle,
                        label: '完成进度',
                        value: '${(stats.completionRate * 100).toStringAsFixed(0)}%',
                        subtitle: '${stats.answeredQuestions} 题',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // 第三行：错题和收藏
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.error_outline,
                        label: '错题总数',
                        value: '${stats.totalWrongQuestions}',
                        subtitle: '需要巩固',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.star,
                        label: '收藏总数',
                        value: '${stats.totalFavorites}',
                        subtitle: '重点题目',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(BuildContext context) {
    final accuracy = stats.overallAccuracy;
    IconData icon;
    String label;
    Color color;

    if (accuracy >= 0.9) {
      icon = Icons.workspace_premium;
      label = '学霸';
      color = Colors.amber;
    } else if (accuracy >= 0.8) {
      icon = Icons.military_tech;
      label = '优秀';
      color = Colors.orange;
    } else if (accuracy >= 0.7) {
      icon = Icons.star;
      label = '良好';
      color = Colors.lightBlue;
    } else {
      icon = Icons.local_fire_department;
      label = '加油';
      color = Colors.red;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalText() {
    if (stats.totalQuestions == 0) {
      return '开始你的学习之旅吧！';
    }

    final accuracy = stats.overallAccuracy;
    final completion = stats.completionRate;

    if (completion >= 0.9) {
      return '太棒了！即将完成所有题目！';
    } else if (completion >= 0.5) {
      return '已经完成一半了，继续加油！';
    } else if (accuracy >= 0.9) {
      return '正确率很高，表现优秀！';
    } else if (accuracy >= 0.7) {
      return '保持这个势头，稳步前进！';
    } else {
      return '持续练习，你会越来越好！';
    }
  }
}
