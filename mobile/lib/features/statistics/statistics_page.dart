import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/stats_provider.dart';
import '../../providers/bank_provider.dart';
import '../bank_list/widgets/bank_options_sheet.dart';
import 'widgets/overall_stats_card.dart';
import 'widgets/bank_stats_card.dart';

/// 统计页面
/// 
/// 显示学习统计、进度和成果
class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallStats = ref.watch(overallStatsProvider);
    final allBankStats = ref.watch(allBankStatsProvider);
    final localBanks = ref.watch(localBanksProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('学习统计'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(overallStatsProvider);
              ref.invalidate(allBankStatsProvider);
            },
            tooltip: '刷新',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(overallStatsProvider);
          ref.invalidate(allBankStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 总体统计卡片
              overallStats.when(
                data: (stats) => OverallStatsCard(stats: stats),
                loading: () => _buildLoadingCard(context),
                error: (error, stack) => _buildErrorCard(context, error),
              ),

              SizedBox(height: 16.h),

              // 各题库统计列表
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '题库详情',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (allBankStats.hasValue &&
                        allBankStats.value!.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          // TODO: 导出数据功能
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('导出功能开发中...')),
                          );
                        },
                        icon: const Icon(Icons.file_download, size: 18),
                        label: const Text('导出'),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // 题库统计列表
              allBankStats.when(
                data: (statsList) {
                  if (statsList.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return localBanks.when(
                    data: (banks) {
                      // 创建题库ID到名称的映射
                      final bankNames = {
                        for (var bank in banks) bank.id: bank.name
                      };

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: statsList.length,
                        itemBuilder: (context, index) {
                          final stats = statsList[index];
                          final bankName =
                              bankNames[stats.bankId] ?? stats.bankId;

                          return BankStatsCard(
                            bankId: stats.bankId,
                            bankName: bankName,
                            stats: stats,
                            onTap: () => BankOptionsSheet.show(
                              context,
                              ref,
                              stats.bankId,
                              bankName,
                            ),
                          );
                        },
                      );
                    },
                    loading: () => _buildLoadingList(context),
                    error: (_, __) => _buildEmptyState(context),
                  );
                },
                loading: () => _buildLoadingList(context),
                error: (error, stack) => _buildErrorState(context, error),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, Object error) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 8.h),
          Text(
            '加载失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        height: 120.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(48.w),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64.sp,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无统计数据',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            '开始刷题后，这里会显示你的学习统计',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Container(
      padding: EdgeInsets.all(48.w),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            '加载失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
