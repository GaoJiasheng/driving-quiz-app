# Providers - 状态管理层

这个目录包含应用的所有 Riverpod Providers，负责状态管理和业务逻辑。

## 📁 文件说明

### 1. database_provider.dart
**基础设施Providers**

- `databaseProvider` - 数据库实例（单例）
- `apiClientProvider` - API客户端（单例）
- `bankRepositoryProvider` - 题库仓库
- `answerRepositoryProvider` - 答题记录仓库
- `statsRepositoryProvider` - 统计仓库

### 2. bank_provider.dart
**题库相关Providers**

- `localBanksProvider` - 本地题库列表
- `remoteBanksProvider` - 远程题库列表
- `bankByIdProvider` - 根据ID获取题库
- `bankDownloadedProvider` - 检查题库是否已下载
- `bankDownloadProvider` - 题库下载管理器
- `selectedBankIdProvider` - 当前选中的题库ID
- `selectedBankProvider` - 当前选中的题库详情

### 3. quiz_provider.dart
**刷题相关Providers**

- `quizProvider` - 刷题状态管理
- `isCurrentQuestionFavoriteProvider` - 当前题目是否已收藏
- `isCurrentQuestionWrongProvider` - 当前题目是否在错题本

**刷题模式**：
- `QuizMode.sequential` - 顺序模式
- `QuizMode.random` - 随机模式
- `QuizMode.wrongQuestions` - 错题模式
- `QuizMode.favorites` - 收藏模式

### 4. stats_provider.dart
**统计相关Providers**

- `bankStatsProvider` - 指定题库的统计数据
- `allBankStatsProvider` - 所有题库的统计列表
- `bankProgressProvider` - 题库进度
- `wrongQuestionsProvider` - 错题列表
- `favoritesProvider` - 收藏列表
- `overallStatsProvider` - 总体统计数据
- `bankResetProvider` - 题库重置操作

## 🔧 使用方法

### 在Widget中使用Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/bank_provider.dart';

class BankListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听本地题库列表
    final localBanks = ref.watch(localBanksProvider);
    
    return localBanks.when(
      data: (banks) => ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) => BankCard(bank: banks[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### 调用Provider的方法

```dart
// 在事件处理中
onPressed: () async {
  final notifier = ref.read(bankDownloadProvider.notifier);
  final success = await notifier.downloadBank('demo_bank');
  
  if (success) {
    // 下载成功，刷新列表
    ref.invalidate(localBanksProvider);
  }
}
```

### 开始刷题

```dart
// 获取题库
final bank = await ref.read(bankByIdProvider('demo_bank').future);

if (bank != null) {
  // 开始刷题
  final quizNotifier = ref.read(quizProvider.notifier);
  await quizNotifier.startQuiz(bank, mode: QuizMode.sequential);
}
```

### 提交答案

```dart
// 用户选择了选项 [0, 2]
final quizNotifier = ref.read(quizProvider.notifier);
await quizNotifier.submitAnswer([0, 2]);

// 查看是否正确
final quizState = ref.read(quizProvider);
final isCorrect = quizState.isCurrentCorrect; // true/false/null
```

## 🎯 Provider层级关系

```
基础设施层 (database_provider.dart)
  └─ databaseProvider
  └─ apiClientProvider
       │
       ├─ bankRepositoryProvider ──┐
       ├─ answerRepositoryProvider │
       └─ statsRepositoryProvider  │
                                   │
业务逻辑层                          │
  ├─ bank_provider.dart ───────────┘
  │   └─ 题库列表、下载管理
  │
  ├─ quiz_provider.dart
  │   └─ 刷题状态、答题逻辑
  │
  └─ stats_provider.dart
      └─ 统计数据、进度管理
```

## 📊 状态刷新

### 自动刷新
某些Provider会自动监听依赖的变化并刷新。

### 手动刷新
```dart
// 刷新本地题库列表（下载后调用）
ref.invalidate(localBanksProvider);

// 刷新统计数据（答题后调用）
ref.invalidate(bankStatsProvider('demo_bank'));

// 刷新错题列表（答错后自动更新，也可手动刷新）
ref.invalidate(wrongQuestionsProvider('demo_bank'));
```

## 🔄 Provider生命周期

- `Provider` - 单例，整个应用共享，直到应用关闭
- `FutureProvider` - 异步数据，有缓存，可手动刷新
- `StateNotifier` - 可变状态，支持复杂的状态管理

## 🛠️ 开发提示

1. **避免直接在UI中调用Repository** - 始终通过Provider访问数据
2. **使用`ref.invalidate()`刷新数据** - 在数据变更后刷新相关Provider
3. **监听加载状态** - 使用`.when()`处理loading/error/data三种状态
4. **合理使用family** - 对于需要参数的Provider使用`.family`
5. **注意Provider依赖** - 避免循环依赖

## 📝 后续扩展

可以继续添加的Providers：
- `settingsProvider` - 应用设置（主题、语言等）
- `authProvider` - 用户认证（如果需要）
- `syncProvider` - 数据同步（如果需要）
- `notificationProvider` - 通知管理

---

**创建时间**: 2026-01-23  
**状态**: ✅ 完成  
**下一步**: 开发UI功能模块
