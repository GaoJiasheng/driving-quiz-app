import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/database_provider.dart';
import 'providers/bank_provider.dart';
import 'providers/stats_provider.dart';

/// Provider测试页面
/// 
/// 用于测试所有Providers是否正常工作
class TestProvidersPage extends ConsumerWidget {
  const TestProvidersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider 测试'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 标题
          const Text(
            '🧪 Provider 功能测试',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // API健康检查
          _buildTestCard(
            title: '1. API 健康检查',
            icon: Icons.health_and_safety,
            child: _ApiHealthTest(),
          ),

          const SizedBox(height: 16),

          // 远程题库列表
          _buildTestCard(
            title: '2. 远程题库列表',
            icon: Icons.cloud_download,
            child: _RemoteBanksTest(),
          ),

          const SizedBox(height: 16),

          // 本地题库列表
          _buildTestCard(
            title: '3. 本地题库列表',
            icon: Icons.storage,
            child: _LocalBanksTest(),
          ),

          const SizedBox(height: 16),

          // 总体统计
          _buildTestCard(
            title: '4. 总体统计',
            icon: Icons.analytics,
            child: _OverallStatsTest(),
          ),

          const SizedBox(height: 16),

          // 下载测试
          _buildTestCard(
            title: '5. 题库下载测试',
            icon: Icons.download,
            child: _DownloadTest(),
          ),

          const SizedBox(height: 24),

          // 说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                    SizedBox(width: 8),
                    Text(
                      '测试说明',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text('• 确保后端服务运行在 http://localhost:8080'),
                Text('• 所有测试应该正常显示数据或错误信息'),
                Text('• 如果看到加载中，说明Provider正在工作'),
                Text('• 如果看到错误，检查后端服务和网络'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// API健康检查测试
class _ApiHealthTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final apiClient = ref.read(apiClientProvider);
          final result = await apiClient.healthCheck();
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ API正常: ${result['status']}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ API错误: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: const Text('测试API连接'),
    );
  }
}

/// 远程题库列表测试
class _RemoteBanksTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteBanks = ref.watch(remoteBanksProvider);

    return remoteBanks.when(
      data: (banks) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✅ 找到 ${banks.length} 个远程题库'),
          const SizedBox(height: 8),
          ...banks.map((bank) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('• ${bank.name} (${bank.totalQuestions}题)'),
              )),
        ],
      ),
      loading: () => const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('正在获取远程题库...'),
        ],
      ),
      error: (error, stack) => Text(
        '❌ 错误: $error',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

/// 本地题库列表测试
class _LocalBanksTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localBanks = ref.watch(localBanksProvider);

    return localBanks.when(
      data: (banks) {
        if (banks.isEmpty) {
          return const Text('📦 暂无本地题库（请先下载）');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ 找到 ${banks.length} 个本地题库'),
            const SizedBox(height: 8),
            ...banks.map((bank) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• ${bank.name} (${bank.totalQuestions}题)'),
                )),
          ],
        );
      },
      loading: () => const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('正在读取本地题库...'),
        ],
      ),
      error: (error, stack) => Text(
        '❌ 错误: $error',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

/// 总体统计测试
class _OverallStatsTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallStats = ref.watch(overallStatsProvider);

    return overallStats.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✅ 统计数据加载成功'),
          const SizedBox(height: 8),
          Text('• 题库总数: ${stats.totalBanks}'),
          Text('• 题目总数: ${stats.totalQuestions}'),
          Text('• 已答题数: ${stats.answeredQuestions}'),
          Text('• 正确率: ${(stats.overallAccuracy * 100).toStringAsFixed(1)}%'),
        ],
      ),
      loading: () => const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('正在计算统计数据...'),
        ],
      ),
      error: (error, stack) => Text(
        '❌ 错误: $error',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

/// 下载测试
class _DownloadTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadStates = ref.watch(bankDownloadProvider);
    
    // 检查是否有正在下载的任务
    final isDownloading = downloadStates.values.any((state) => state.isDownloading);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: isDownloading
              ? null
              : () async {
                  final notifier = ref.read(bankDownloadProvider.notifier);
                  final success = await notifier.downloadBank('demo_bank');

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? '✅ 下载成功！' : '❌ 下载失败',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );

                    if (success) {
                      // 刷新本地题库列表
                      ref.invalidate(localBanksProvider);
                    }
                  }
                },
          child: Text(isDownloading ? '下载中...' : '下载 Demo 题库'),
        ),
        
        if (downloadStates.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...downloadStates.entries.map((entry) {
            final state = entry.value;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${state.bankId}: ${(state.progress * 100).toStringAsFixed(0)}%'),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: state.progress),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
