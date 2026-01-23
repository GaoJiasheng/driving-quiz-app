import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/bank_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/quiz_provider.dart';
import '../quiz/quiz_page.dart';
import 'widgets/local_bank_card.dart';
import 'widgets/remote_bank_card.dart';
import 'widgets/empty_state.dart';

/// 题库列表页
/// 
/// 显示本地已下载和远程可下载的题库
class BankListPage extends ConsumerStatefulWidget {
  const BankListPage({super.key});

  @override
  ConsumerState<BankListPage> createState() => _BankListPageState();
}

class _BankListPageState extends ConsumerState<BankListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overallStats = ref.watch(overallStatsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '搜索题库名称...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
              )
            : const Text('驾考刷刷'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // 搜索按钮
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
            tooltip: _isSearching ? '取消搜索' : '搜索',
          ),
          // 刷新按钮
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // 刷新数据
                ref.invalidate(localBanksProvider);
                ref.invalidate(remoteBanksProvider);
                ref.invalidate(overallStatsProvider);
              },
              tooltip: '刷新',
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: Column(
            children: [
              // 统计卡片
              _buildStatsCard(overallStats),
              SizedBox(height: 8.h),
              // Tab标签
              TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: '我的题库'),
                  Tab(text: '题库商店'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 本地题库列表
          _buildLocalBanksList(),
          // 远程题库列表
          _buildRemoteBanksList(),
        ],
      ),
    );
  }

  /// 统计卡片
  Widget _buildStatsCard(AsyncValue<dynamic> overallStats) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: overallStats.when(
        data: (stats) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.collections_bookmark,
              label: '题库',
              value: '${stats.totalBanks}',
            ),
            _buildStatItem(
              icon: Icons.quiz,
              label: '总题数',
              value: '${stats.totalQuestions}',
            ),
            _buildStatItem(
              icon: Icons.check_circle,
              label: '已答',
              value: '${stats.answeredQuestions}',
            ),
            _buildStatItem(
              icon: Icons.trending_up,
              label: '正确率',
              value: '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
            ),
          ],
        ),
        loading: () => const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
        error: (_, __) => const Text(
          '统计数据加载失败',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  /// 本地题库列表
  Widget _buildLocalBanksList() {
    final localBanks = ref.watch(localBanksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(localBanksProvider);
        ref.invalidate(overallStatsProvider);
      },
      child: localBanks.when(
        data: (banks) {
          // 根据搜索查询过滤题库
          final filteredBanks = _searchQuery.isEmpty
              ? banks
              : banks.where((bank) {
                  return bank.name.toLowerCase().contains(_searchQuery) ||
                      bank.description.toLowerCase().contains(_searchQuery);
                }).toList();

          if (filteredBanks.isEmpty) {
            if (_searchQuery.isNotEmpty) {
              return EmptyState(
                icon: Icons.search_off,
                title: '没有找到题库',
                message: '试试其他关键词吧',
                actionText: '清除搜索',
                onAction: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              );
            }
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: '还没有题库',
              message: '去「题库商店」下载题库开始刷题吧！',
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredBanks.length,
            itemBuilder: (context, index) {
              final bank = filteredBanks[index];
              return LocalBankCard(
                bank: bank,
                onTap: () {
                  // 选中题库并跳转到刷题页面
                  ref.read(selectedBankIdProvider.notifier).state =
                      bank.id;
                  
                  // 跳转到刷题页面
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bankId: bank.id,
                        mode: QuizMode.sequential,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  // 确认删除
                  final confirmed = await _showDeleteConfirmDialog(
                    context,
                    bank.name,
                  );

                  if (confirmed == true && context.mounted) {
                    // 删除题库
                    final notifier = ref.read(bankDownloadProvider.notifier);
                    await notifier.deleteBank(bank.id);

                    // 刷新列表
                    ref.invalidate(localBanksProvider);
                    ref.invalidate(overallStatsProvider);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('题库已删除')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(localBanksProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 远程题库列表
  Widget _buildRemoteBanksList() {
    final remoteBanks = ref.watch(remoteBanksProvider);
    final localBanks = ref.watch(localBanksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(remoteBanksProvider);
      },
      child: remoteBanks.when(
        data: (banks) {
          // 根据搜索查询过滤题库
          final filteredBanks = _searchQuery.isEmpty
              ? banks
              : banks.where((bank) {
                  return bank.name.toLowerCase().contains(_searchQuery) ||
                      bank.description.toLowerCase().contains(_searchQuery) ||
                      bank.language.toLowerCase().contains(_searchQuery);
                }).toList();

          if (filteredBanks.isEmpty) {
            if (_searchQuery.isNotEmpty) {
              return EmptyState(
                icon: Icons.search_off,
                title: '没有找到题库',
                message: '试试其他关键词吧',
                actionText: '清除搜索',
                onAction: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              );
            }
            return const EmptyState(
              icon: Icons.cloud_off_outlined,
              title: '暂无可用题库',
              message: '服务器上还没有题库，请稍后再试',
            );
          }

          // 获取已下载题库的ID集合
          final downloadedIds = localBanks.whenOrNull(
                data: (locals) => locals.map((b) => b.id).toSet(),
              ) ??
              {};

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredBanks.length,
            itemBuilder: (context, index) {
              final bank = filteredBanks[index];
              final isDownloaded = downloadedIds.contains(bank.id);

              return RemoteBankCard(
                bankInfo: bank,
                isDownloaded: isDownloaded,
                onDownload: () async {
                  // 开始下载
                  final notifier = ref.read(bankDownloadProvider.notifier);
                  final success = await notifier.downloadBank(bank.id);

                  if (success && context.mounted) {
                    // 刷新本地列表
                    ref.invalidate(localBanksProvider);
                    ref.invalidate(overallStatsProvider);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${bank.name} 下载成功！'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${bank.name} 下载失败'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 64.sp,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: 16.h),
              Text(
                '连接失败',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  '无法连接到服务器，请检查网络或后端服务',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(remoteBanksProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  Future<bool?> _showDeleteConfirmDialog(
    BuildContext context,
    String bankName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「$bankName」吗？\n\n删除后答题记录将保留。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
