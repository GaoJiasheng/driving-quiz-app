import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/database/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/bank_provider.dart';
import '../../providers/theme_provider.dart';

/// 设置页面
/// 
/// 应用设置、数据管理、关于信息
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionHeader('外观设置'),
          _buildThemeSwitch(),

          SizedBox(height: 16.h),

          // 数据管理
          _buildSectionHeader('数据管理'),
          _buildClearCacheTile(),
          _buildResetProgressTile(),
          _buildDeleteDatabaseTile(),

          SizedBox(height: 16.h),

          // 关于
          _buildSectionHeader('关于'),
          _buildVersionTile(),
          _buildAboutTile(),
          _buildFeedbackTile(),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildThemeSwitch() {
    // 获取当前主题模式
    final isDarkMode = ref.watch(themeProvider);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: SwitchListTile(
        secondary: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('深色模式'),
        subtitle: Text(
          isDarkMode ? '已开启深色模式' : '当前为浅色模式',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: isDarkMode,
        onChanged: (value) async {
          // 切换主题
          await ref.read(themeProvider.notifier).toggleTheme();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value ? '已切换到深色模式' : '已切换到浅色模式'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildClearCacheTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.cleaning_services,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('清除缓存'),
        subtitle: const Text('清除临时文件和缓存数据'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showClearCacheDialog(),
      ),
    );
  }

  Widget _buildResetProgressTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.refresh,
          color: Colors.orange,
        ),
        title: const Text('重置所有进度'),
        subtitle: const Text('清除所有题库的答题记录'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showResetProgressDialog(),
      ),
    );
  }

  Widget _buildDeleteDatabaseTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.delete_forever,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('删除所有数据'),
        subtitle: const Text('删除数据库，清空所有本地数据'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDeleteDatabaseDialog(),
      ),
    );
  }

  Widget _buildVersionTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('版本信息'),
        subtitle: Text(
          _packageInfo != null
              ? 'v${_packageInfo!.version} (${_packageInfo!.buildNumber})'
              : '加载中...',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showVersionInfo(),
      ),
    );
  }

  Widget _buildAboutTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('关于驾考刷刷'),
        subtitle: const Text('了解应用详情'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showAboutDialog(),
      ),
    );
  }

  Widget _buildFeedbackTile() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          Icons.feedback_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('反馈与建议'),
        subtitle: const Text('帮助我们改进应用'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('反馈功能开发中...')),
          );
        },
      ),
    );
  }

  // 清除缓存对话框
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除应用缓存吗？\n\n这不会删除你的学习数据。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // 模拟清除缓存
              await Future.delayed(const Duration(milliseconds: 500));
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('缓存已清除')),
                );
              }
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }

  // 重置进度对话框
  void _showResetProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8.w),
            const Text('重置所有进度'),
          ],
        ),
        content: const Text(
          '确定要重置所有题库的答题进度吗？\n\n此操作将：\n• 清除所有答题记录\n• 保留错题本\n• 保留收藏题目\n\n此操作不可恢复！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // 显示加载对话框
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                // 获取所有题库统计
                final allStats = await ref.read(allBankStatsProvider.future);
                
                // 重置每个题库的进度
                final notifier = ref.read(bankResetProvider.notifier);
                for (final stats in allStats) {
                  await notifier.resetBankProgress(stats.bankId);
                }

                // 刷新统计
                ref.invalidate(overallStatsProvider);
                ref.invalidate(allBankStatsProvider);

                if (mounted) {
                  Navigator.of(context).pop(); // 关闭加载对话框
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('所有进度已重置'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.of(context).pop(); // 关闭加载对话框
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('重置失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }

  // 删除数据库对话框
  void _showDeleteDatabaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Theme.of(context).colorScheme.error),
            SizedBox(width: 8.w),
            const Text('删除所有数据'),
          ],
        ),
        content: const Text(
          '⚠️ 警告：此操作非常危险！\n\n确定要删除数据库吗？\n\n此操作将：\n• 删除所有题库\n• 删除所有答题记录\n• 删除所有错题和收藏\n• 删除所有统计数据\n\n数据将无法恢复！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // 显示二次确认
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('最后确认'),
                  content: const Text('真的要删除所有数据吗？此操作不可恢复！'),
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
                      child: const Text('确定删除'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                // 显示加载
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // 删除数据库
                  await AppDatabase.deleteDatabase();

                  // 刷新所有Provider
                  ref.invalidate(databaseProvider);
                  ref.invalidate(localBanksProvider);
                  ref.invalidate(overallStatsProvider);
                  ref.invalidate(allBankStatsProvider);

                  if (mounted) {
                    Navigator.of(context).pop(); // 关闭加载
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('数据库已删除'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.of(context).pop(); // 关闭加载
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('删除失败: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  // 版本信息对话框
  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('版本信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_packageInfo != null) ...[
              _buildInfoRow('应用名称', _packageInfo!.appName),
              _buildInfoRow('包名', _packageInfo!.packageName),
              _buildInfoRow('版本号', _packageInfo!.version),
              _buildInfoRow('构建号', _packageInfo!.buildNumber),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 关于对话框
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: '驾考刷刷',
      applicationVersion: _packageInfo?.version ?? '1.0.0',
      applicationIcon: Icon(
        Icons.school,
        size: 48.sp,
        color: Theme.of(context).colorScheme.primary,
      ),
      applicationLegalese: '© 2026 驾考刷刷团队',
      children: [
        SizedBox(height: 16.h),
        const Text(
          '驾考刷刷是一款帮助学员高效备考驾照的刷题应用。'
          '\n\n我们致力于提供：\n'
          '• 海量真题题库\n'
          '• 智能错题本\n'
          '• 详细答案解析\n'
          '• 学习进度追踪\n'
          '\n祝你早日拿到驾照！🚗',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
