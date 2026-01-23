# 驾考刷刷 PRD（产品需求文档）

---

## 目录

1. [产品概述](#1-产品概述)
2. [功能需求](#2-功能需求)
3. [技术架构](#3-技术架构)
4. [用户体验设计](#4-用户体验设计)
   - 4.1 设计理念与风格
   - 4.2 色彩系统
   - 4.3 排版系统
   - 4.4 间距与网格
   - 4.5 圆角与阴影
   - 4.6 动效设计
   - 4.7 触觉反馈
   - 4.8 组件设计规范
   - 4.9 图标与插图
   - 4.10 情感化设计
   - 4.11 无障碍设计
   - 4.12 App图标与启动页
   - 4.13 交互流程设计
   - 4.14 空状态与错误状态设计
   - 4.15 核心页面详细设计
5. [页面流程图](#5-页面流程图)
6. [功能优先级](#6-功能优先级)
7. [非功能需求](#7-非功能需求)
8. [约束条件](#8-约束条件)
9. [后续迭代方向](#9-后续迭代方向)
10. [成功指标](#10-成功指标)
11. [风险与应对](#11-风险与应对)
12. [测试用例概要](#12-测试用例概要)
13. [隐私政策](#13-隐私政策)
14. [附录](#14-附录)

---

## 1. 产品概述

### 1.1 产品基础信息

| 项目 | 内容 |
|------|------|
| **产品名称** | 驾考刷刷 |
| **英文名称** | DriveQuiz |
| **Slogan** | 刷题轻松过，驾考无压力 |
| **平台** | iOS / Android |
| **版本** | V1.0 |

### 1.2 产品定位
一款专注于驾校题目练习的移动应用，提供类似"百词斩"的卡片式刷题体验，支持多题库、离线使用、错题回顾等核心功能。

### 1.3 目标用户
- 正在备考驾照的学员
- 需要系统化练习驾考题目的用户
- 需要多题库支持的用户（不同地区、不同科目）

### 1.4 核心价值
- 简洁高效的卡片式刷题体验
- 智能的学习进度记录和错题管理
- 支持离线使用，随时随地练习
- 多题库切换，满足不同需求

---

## 2. 功能需求

### 2.1 题库管理模块

#### 2.1.1 题库列表页
**功能描述**：展示已下载和可下载的题库

**界面元素**：
- **已下载题库区域**
  - 题库名称
  - 题目总数
  - 已刷进度（已刷/总数）
  - 正确率百分比
  - 进入按钮
  - 删除按钮
  
- **可下载题库区域**
  - 题库名称
  - 题目总数
  - 下载按钮

**交互逻辑**：
- 点击已下载题库 → 进入该题库的刷题界面
- 点击下载按钮 → 显示下载进度条
- 下载完成 → 题库移至"已下载"区域
- 下载失败 → 提示错误信息，用户可手动重试
- 长按或点击删除 → 弹出确认对话框 → 删除题库（不删除答题记录）

#### 2.1.2 内置默认题库
**功能描述**：App安装包内置一个默认题库，用户无需下载即可开始使用

**内置题库规格**：
- 名称：示例题库（Demo）
- 题目数量：50题（包含单选、多选、判断题各类型）
- 用途：让用户首次使用即可体验核心功能

#### 2.1.3 题库下载
**功能描述**：从云端下载题库数据

**技术要点**：
- 显示下载进度（百分比 + 进度条）
- 图片资源与题库JSON一起打包下载
- 下载失败：显示错误提示，提供"重试"按钮
- 题库数据存储在本地（SQLite）

**存储空间不足**：
- 弹窗提示："存储空间不足，无法下载题库。请清理设备空间后重试。"
- 提供"确定"按钮关闭弹窗

#### 2.1.4 题库更新
**功能描述**：检测并更新已下载题库的新版本

**更新机制**：
- 每次进入题库列表页时，自动检测已下载题库是否有新版本
- 如有新版本，在题库卡片上显示"有更新"标识
- 点击后弹窗提示："发现新版本，是否更新？更新不会影响您的答题记录。"
- 用户确认后开始下载更新

**数据保留策略**：
- 更新题库后，保留以下用户数据：
  - 答题记录
  - 错题本
  - 收藏夹
  - 刷题进度
- 如果新版本删除了某些题目，对应的记录自动清理

---

### 2.2 刷题模块

#### 2.2.1 刷题模式选择
**支持的模式**：
1. **顺序模式**（默认）
   - 按题目顺序从第一题刷到最后
   - 记录上次刷到的位置，下次继续
   - 记录每道题是否已刷过

2. **随机模式**
   - 随机抽取题目
   - 记录已刷过的题目，避免重复
   - 可通过"重置进度"清空已刷记录

3. **错题模式**
   - 只显示做错过的题目
   - 按顺序刷题
   - 提供"已掌握"按钮，标记后从错题本移除

4. **收藏模式**
   - 只显示收藏的题目
   - 按顺序刷题
   - 可取消收藏

**交互逻辑**：
- 进入题库后默认进入"顺序模式"
- 界面顶部有"模式切换"按钮
- 点击按钮弹出模式选择菜单

#### 2.2.2 答题界面（卡片式）
**界面布局**：
```
+----------------------------------+
|  [模式] [统计]          [退出]   |
+----------------------------------+
|                                  |
|   进度：125 / 5000               |
|                                  |
|  +----------------------------+  |
|  |                            |  |
|  |  【题目内容】              |  |
|  |                            |  |
|  |  （可能有图片）            |  |
|  |                            |  |
|  +----------------------------+  |
|                                  |
|  [ ] A. 选项内容               |
|  [ ] B. 选项内容               |
|  [ ] C. 选项内容               |
|  [ ] D. 选项内容               |
|                                  |
|  [上一题] [跳过] [确认] [收藏⭐] |
|                                  |
+----------------------------------+
```

**功能元素**：
- **题目区域**
  - 题目文字
  - 题目图片（如有）
  - 题目类型标识（单选/多选）

- **选项区域**
  - 单选题：单选按钮（radio）
  - 多选题：复选框（checkbox）
  
- **操作按钮**
  - 上一题：返回上一道题（已作答的题显示之前的答案和解析）
  - 跳过：跳过当前题，标记为"未作答"，进入下一题
  - 确认：提交答案（单选可自动提交，多选需点击确认）
  - 收藏：五角星图标，黄色=已收藏，白色=未收藏

- **顶部信息**
  - 当前模式（顺序/随机/错题/收藏）
  - 当前进度（第X题 / 共Y题）
  - 统计按钮：查看当前题库统计数据
  - 退出按钮：返回题库列表

**交互逻辑**：
1. **答题前**
   - 选择答案
   - 点击"确认"提交（多选题）或自动提交（单选题）

2. **答题后**
   - 立即显示对错反馈
     - 答对：绿色提示 ✓ 正确
     - 答错：红色提示 ✗ 错误，显示正确答案
   - 显示题目解析（如有）
   - 错题模式下额外显示"已掌握"按钮
   - 按钮文字变为"下一题"
   - 点击"下一题"进入下一道题

3. **收藏功能**
   - 任何时候都可以点击五角星收藏/取消收藏
   - 收藏状态实时更新

4. **上一题功能**
   - 可以返回查看已答过的题
   - 显示之前的答题结果和解析
   - 可以重新作答（记录最新答案）

5. **跳过功能**
   - 标记为"未作答"
   - 顺序模式下，下次可以继续刷到
   - 不影响进度统计

#### 2.2.3 题型支持
- **单选题**：4个选项，单选，一个正确答案
- **多选题**：4个选项，多选，一个或多个正确答案
- **判断题**：2个选项（正确/错误），单选

#### 2.2.4 手势交互
- **左右滑动**：支持左右滑动手势切换上一题/下一题
  - 向左滑动：下一题
  - 向右滑动：上一题
- **点击按钮**：仍保留按钮操作，手势和按钮并存
- **返回操作**：刷题界面按返回键直接退出，无需确认

#### 2.2.5 边界情况处理
- **刷完所有题**：
  - 顺序模式刷到最后一题后，弹窗提示"恭喜！您已完成全部题目"
  - 提供两个选项："从头再刷" / "返回题库"
  - 选择"从头再刷"：清空刷题进度状态，但保留错题和收藏
- **随机模式刷完**：
  - 所有题目都已刷过后，提示"您已完成全部题目的随机练习"
  - 提供"重置进度重新开始"选项

---

### 2.3 错题本模块

#### 2.3.1 错题记录规则
- 只要做错过一次，立即加入错题本
- 重新答对不自动移除
- 需要用户在错题模式下手动点击"已掌握"按钮才移除

#### 2.3.2 错题模式刷题
**界面**：与普通刷题完全一致，额外增加：
- 按钮："已掌握"（显著的绿色按钮）
- 点击后：题目从错题本移除，提示"已移出错题本"，自动进入下一题

**特点**：
- 只显示错题
- 按题目顺序展示（不需要随机）
- 卡片式交互

---

### 2.4 收藏模块

#### 2.4.1 收藏功能
- 答题界面有五角星收藏按钮
- 黄色五角星 = 已收藏
- 白色五角星 = 未收藏
- 点击切换状态

#### 2.4.2 收藏模式刷题
**界面**：与错题模式类似
- 只显示收藏的题目
- 可以取消收藏（点击五角星）
- 卡片式刷题

**特点**：
- 按题库分类
- 按顺序展示

---

### 2.5 统计模块

#### 2.5.1 题库列表页统计
**显示内容**：
- 题库名称
- 总题数
- 已刷进度：已刷题数 / 总题数
- 正确率：X%
- 错题数
- 收藏数

#### 2.5.2 独立统计页面
**功能描述**：查看详细的答题统计数据

**统计维度**（按题库）：
- 题库名称
- 总题数
- 已刷题数
- 未刷题数
- 正确率
- 答对题数
- 答错题数
- 错题数（当前错题本中的数量）
- 收藏数

**界面形式**：
- 列表或卡片式展示
- 可以点击跳转到对应题库

---

### 2.6 数据管理模块

#### 2.6.1 数据记录
**记录内容**（每道题）：
- 题目ID
- 是否已刷过
- 用户答案
- 是否正确
- 答题时间戳
- 是否错题
- 是否收藏
- 错题是否已掌握

**存储方式**：
- 本地数据库（SQLite/Realm/CoreData）
- 按题库分表或分区
- 永久保存，除非用户主动清除

#### 2.6.2 数据重置
**功能描述**：清除某个题库的所有答题记录

**入口**：
- 题库列表页，长按题库 → 弹出菜单
- 菜单选项："重置进度"

**交互逻辑**：
- 点击"重置进度"
- 弹出确认对话框："确定要清除该题库的所有答题记录吗？此操作不可恢复。"
- 确认后：清空该题库的所有答题记录（包括错题、收藏保留，但答题历史清空）

---

### 2.7 多语言支持

#### 2.7.1 语言范围
- 界面语言：中文简体、英文
- 题库内容：保持原题库语言，不翻译

#### 2.7.2 语言切换
- 设置页面提供语言切换选项
- 切换后立即生效
- 保存用户选择

---

### 2.8 其他功能

#### 2.8.1 设置页面
**功能列表**：
- 语言切换（中文/English）
- 关于页面（版本号、开发者信息）
- 清除所有数据（需二次确认）

#### 2.8.2 离线支持
- 题库下载后完全支持离线使用
- 答题记录本地存储
- 无需登录，无需联网（下载题库时除外）

---

## 3. 技术架构

### 3.1 技术栈总览

#### 3.1.1 架构图
```
┌─────────────────────────────────────────────────┐
│                   移动端                        │
│             Flutter (iOS/Android)               │
│  ┌──────────────────────────────────────────┐  │
│  │  UI Layer (Material/Cupertino)          │  │
│  ├──────────────────────────────────────────┤  │
│  │  State Management (Riverpod)            │  │
│  ├──────────────────────────────────────────┤  │
│  │  Business Logic (Services/Repositories) │  │
│  ├──────────────────────────────────────────┤  │
│  │  Local Storage (SQLite + Drift)         │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                        ↕ HTTP(S)
┌─────────────────────────────────────────────────┐
│                   后端服务                      │
│               Golang + Gin Framework            │
│  ┌──────────────────────────────────────────┐  │
│  │  RESTful API (题库列表、下载)           │  │
│  ├──────────────────────────────────────────┤  │
│  │  File Service (JSON文件读取)            │  │
│  ├──────────────────────────────────────────┤  │
│  │  题库数据 (本地JSON文件)                │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### 3.2 移动端技术栈（Flutter）

#### 3.2.1 平台支持
- **iOS**：iOS 13+
- **Android**：Android 8.0+ (API Level 26+)
- **Flutter版本**：Flutter 3.19+ / Dart 3.3+

#### 3.2.2 核心依赖库

**状态管理**：
```yaml
riverpod: ^2.5.0              # 状态管理框架
flutter_riverpod: ^2.5.0      # Flutter集成
```

**本地存储**：
```yaml
drift: ^2.16.0                # SQLite ORM，类型安全
sqlite3_flutter_libs: ^0.5.0 # SQLite原生库
path_provider: ^2.1.0         # 文件路径管理
path: ^1.8.3                  # 路径工具
```

**网络请求**：
```yaml
dio: ^5.4.0                   # HTTP客户端
pretty_dio_logger: ^1.3.1     # 网络请求日志（开发用）
```

**UI组件**：
```yaml
flutter_screenutil: ^5.9.0    # 屏幕适配
cached_network_image: ^3.3.1  # 图片缓存
flutter_svg: ^2.0.10          # SVG支持
shimmer: ^3.0.0               # 加载动画
```

**工具库**：
```yaml
intl: ^0.19.0                 # 国际化
shared_preferences: ^2.2.2    # 轻量级KV存储（设置）
equatable: ^2.0.5             # 对象比较
json_annotation: ^4.8.1       # JSON序列化
```

**开发工具**：
```yaml
# dev_dependencies
build_runner: ^2.4.0          # 代码生成
drift_dev: ^2.16.0            # Drift代码生成
json_serializable: ^6.7.1     # JSON代码生成
flutter_launcher_icons: ^0.13.1  # 应用图标生成
```

#### 3.2.3 项目结构
```
lib/
├── main.dart                    # 应用入口
├── app.dart                     # App根组件
├── config/                      # 配置文件
│   ├── app_config.dart          # 应用配置（API地址等）
│   └── theme.dart               # 主题配置
├── core/                        # 核心层
│   ├── database/                # 数据库
│   │   ├── database.dart        # Drift数据库定义
│   │   ├── database.g.dart      # 自动生成
│   │   └── tables/              # 数据表定义
│   │       ├── question_banks.dart
│   │       ├── answer_records.dart
│   │       ├── bank_progress.dart
│   │       ├── wrong_questions.dart
│   │       └── favorites.dart
│   ├── network/                 # 网络层
│   │   ├── api_client.dart      # Dio封装
│   │   └── api_endpoints.dart   # API端点
│   ├── storage/                 # 存储
│   │   └── local_storage.dart   # SharedPreferences封装
│   └── utils/                   # 工具类
│       ├── logger.dart          # 日志
│       └── constants.dart       # 常量
├── data/                        # 数据层
│   ├── models/                  # 数据模型
│   │   ├── question_bank.dart
│   │   ├── question.dart
│   │   └── answer_record.dart
│   └── repositories/            # 数据仓库
│       ├── bank_repository.dart
│       ├── question_repository.dart
│       └── stats_repository.dart
├── providers/                   # Riverpod状态管理
│   ├── bank_provider.dart       # 题库状态
│   ├── question_provider.dart   # 题目状态
│   ├── answer_provider.dart     # 答题状态
│   └── settings_provider.dart   # 设置状态
├── features/                    # 功能模块
│   ├── bank_list/               # 题库列表
│   │   ├── bank_list_page.dart
│   │   └── widgets/
│   ├── quiz/                    # 刷题模块
│   │   ├── quiz_page.dart
│   │   ├── widgets/
│   │   │   ├── question_card.dart
│   │   │   ├── answer_options.dart
│   │   │   └── explanation_card.dart
│   │   └── controllers/
│   ├── statistics/              # 统计模块
│   │   └── stats_page.dart
│   └── settings/                # 设置模块
│       └── settings_page.dart
├── l10n/                        # 国际化
│   ├── app_zh.arb               # 中文
│   └── app_en.arb               # 英文
└── widgets/                     # 通用组件
    ├── loading_indicator.dart
    ├── error_widget.dart
    └── custom_button.dart
```

#### 3.2.4 状态管理方案（Riverpod）

**核心Provider示例**：
```dart
// providers/bank_provider.dart

// 题库列表Provider
final bankListProvider = FutureProvider<List<QuestionBank>>((ref) async {
  final repository = ref.watch(bankRepositoryProvider);
  return repository.getAllBanks();
});

// 当前题库Provider
final currentBankProvider = StateProvider<QuestionBank?>((ref) => null);

// 当前题目Provider
final currentQuestionProvider = Provider<Question?>((ref) {
  final bank = ref.watch(currentBankProvider);
  final index = ref.watch(currentQuestionIndexProvider);
  if (bank == null) return null;
  return bank.questions[index];
});

// 答题模式Provider
final quizModeProvider = StateProvider<QuizMode>((ref) => QuizMode.sequential);

// 统计数据Provider
final statsProvider = FutureProvider.family<BankStats, String>((ref, bankId) async {
  final repository = ref.watch(statsRepositoryProvider);
  return repository.getBankStats(bankId);
});
```

#### 3.2.5 本地数据库设计（Drift）

**数据库定义**：
```dart
// core/database/database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DriftDatabase(tables: [
  QuestionBanks,
  AnswerRecords,
  BankProgress,
  WrongQuestions,
  Favorites,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'quiz_app.db'));
      return NativeDatabase(file);
    });
  }
}
```

**表定义示例**：
```dart
// core/database/tables/question_banks.dart
class QuestionBanks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get version => text()();
  IntColumn get totalQuestions => integer()();
  TextColumn get language => text()();
  DateTimeColumn get downloadedAt => dateTime()();
  TextColumn get data => text()(); // JSON存储题目数据
  
  @override
  Set<Column> get primaryKey => {id};
}

// core/database/tables/answer_records.dart
class AnswerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankId => text()();
  TextColumn get questionId => text()();
  TextColumn get userAnswer => text().nullable()(); // JSON数组
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get answeredAt => dateTime()();
}
```

#### 3.2.6 网络层设计

**API Client封装**：
```dart
// core/network/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
    
    // 添加日志拦截器（仅开发环境）
    _dio.interceptors.add(PrettyDioLogger());
  }
  
  // 获取题库列表
  Future<List<QuestionBankInfo>> getBankList() async {
    final response = await _dio.get('/api/banks');
    // 解析并返回
  }
  
  // 下载题库（支持进度回调）
  Future<void> downloadBank(
    String bankId,
    String savePath,
    ProgressCallback onProgress,
  ) async {
    await _dio.download(
      '/api/banks/$bankId/download',
      savePath,
      onReceiveProgress: onProgress,
    );
  }
}
```

### 3.3 后端技术栈（Golang）

#### 3.3.1 核心框架
- **Web框架**：Gin 1.9+
- **Go版本**：Go 1.21+

#### 3.3.2 依赖库
```go
// go.mod
module github.com/yourname/quiz-backend

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1          // Web框架
    github.com/gin-contrib/cors v1.5.0       // CORS中间件
    github.com/joho/godotenv v1.5.1          // 环境变量
    go.uber.org/zap v1.26.0                  // 日志库
)
```

#### 3.3.3 项目结构
```
backend/
├── main.go                      # 入口文件
├── config/                      # 配置
│   └── config.go
├── api/                         # API处理
│   ├── handler.go               # 路由处理器
│   └── middleware.go            # 中间件
├── service/                     # 业务逻辑
│   └── bank_service.go
├── model/                       # 数据模型
│   └── bank.go
├── data/                        # 题库数据目录
│   ├── banks.json               # 题库列表元数据
│   └── banks/                   # 题库文件
│       ├── cn_subject1_v1.json
│       └── cn_subject4_v1.json
├── utils/                       # 工具类
│   └── logger.go
└── Dockerfile                   # Docker部署
```

#### 3.3.4 核心代码设计

**主程序**：
```go
// main.go
package main

import (
    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
    "log"
)

func main() {
    r := gin.Default()
    
    // CORS配置
    r.Use(cors.New(cors.Config{
        AllowOrigins:     []string{"*"},
        AllowMethods:     []string{"GET", "POST"},
        AllowHeaders:     []string{"Origin", "Content-Type"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: false,
    }))
    
    // 路由
    api := r.Group("/api")
    {
        api.GET("/banks", getBankList)              // 获取题库列表
        api.GET("/banks/:id/download", downloadBank) // 下载题库
        api.GET("/health", healthCheck)             // 健康检查
    }
    
    log.Println("Server starting on :8080")
    r.Run(":8080")
}
```

**题库服务**：
```go
// service/bank_service.go
package service

import (
    "encoding/json"
    "io/ioutil"
    "path/filepath"
)

type BankService struct {
    dataDir string
}

func NewBankService(dataDir string) *BankService {
    return &BankService{dataDir: dataDir}
}

// 获取题库列表
func (s *BankService) GetBankList() ([]BankInfo, error) {
    data, err := ioutil.ReadFile(filepath.Join(s.dataDir, "banks.json"))
    if err != nil {
        return nil, err
    }
    
    var banks []BankInfo
    if err := json.Unmarshal(data, &banks); err != nil {
        return nil, err
    }
    
    return banks, nil
}

// 读取题库文件
func (s *BankService) GetBankData(bankID string) ([]byte, error) {
    filePath := filepath.Join(s.dataDir, "banks", bankID+".json")
    return ioutil.ReadFile(filePath)
}
```

**API处理器**：
```go
// api/handler.go
package api

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

var bankService *service.BankService

func init() {
    bankService = service.NewBankService("./data")
}

// 获取题库列表
func getBankList(c *gin.Context) {
    banks, err := bankService.GetBankList()
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "code":    500,
            "message": "Failed to get bank list",
            "error":   err.Error(),
        })
        return
    }
    
    c.JSON(http.StatusOK, gin.H{
        "code":    200,
        "message": "success",
        "data": gin.H{
            "question_banks": banks,
        },
    })
}

// 下载题库
func downloadBank(c *gin.Context) {
    bankID := c.Param("id")
    
    data, err := bankService.GetBankData(bankID)
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{
            "code":    404,
            "message": "Bank not found",
        })
        return
    }
    
    // 设置响应头
    c.Header("Content-Type", "application/json")
    c.Header("Content-Disposition", "attachment; filename="+bankID+".json")
    
    c.Data(http.StatusOK, "application/json", data)
}

// 健康检查
func healthCheck(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
        "status": "ok",
    })
}
```

#### 3.3.5 题库数据管理

**题库列表文件（data/banks.json）**：
```json
{
  "banks": [
    {
      "id": "cn_subject1_v1",
      "name": "中国驾照科目一",
      "description": "科目一理论考试题库",
      "total_questions": 1500,
      "version": "1.0.0",
      "language": "zh-CN",
      "size": 5242880,
      "updated_at": "2026-01-20T10:00:00Z"
    },
    {
      "id": "cn_subject4_v1",
      "name": "中国驾照科目四",
      "description": "科目四安全文明驾驶题库",
      "total_questions": 1200,
      "version": "1.0.0",
      "language": "zh-CN",
      "size": 4718592,
      "updated_at": "2026-01-15T10:00:00Z"
    }
  ]
}
```

**单个题库文件结构（data/banks/cn_subject1_v1.json）**：
```json
{
  "id": "cn_subject1_v1",
  "name": "中国驾照科目一",
  "version": "1.0.0",
  "description": "中国驾照科目一题库",
  "total_questions": 1500,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-20T10:00:00Z",
  "language": "zh-CN",
  "questions": [
    {
      "id": "q001",
      "type": "single",
      "question": "驾驶机动车在道路上违反道路交通安全法的行为，属于什么行为？",
      "image": "",
      "options": [
        "违章行为",
        "违法行为",
        "过失行为",
        "违规行为"
      ],
      "answer": [1],
      "explanation": "违反道路交通安全法的行为属于违法行为。违法行为是指违反法律规定的行为。",
      "chapter": "道路交通安全法律法规"
    }
  ]
}
```

#### 3.3.6 内置默认题库（Demo）

**文件位置**：打包在App的assets目录中

**题库规格**：
```json
{
  "id": "demo_bank",
  "name": "示例题库",
  "version": "1.0.0",
  "description": "内置示例题库，包含各类题型演示",
  "total_questions": 50,
  "language": "zh-CN",
  "questions": [
    // 单选题 x 20
    // 多选题 x 15
    // 判断题 x 15
  ]
}
```

**示例题目**：
```json
{
  "questions": [
    {
      "id": "demo_001",
      "type": "single",
      "question": "机动车仪表板上（如图所示）亮表示什么？",
      "image": "assets/images/demo_001.png",
      "options": ["制动系统异常", "驻车制动器处于解除状态", "驻车制动器处于制动状态", "行车制动系统故障"],
      "answer": [2],
      "explanation": "此标志表示驻车制动器（手刹）处于制动状态。"
    },
    {
      "id": "demo_002",
      "type": "multiple",
      "question": "关于安全带的作用，以下说法正确的是？（多选）",
      "options": ["防止驾驶人在紧急制动时前冲", "减轻事故中的伤害程度", "发生事故时保持正确驾驶姿势", "有效保护颈部不受伤害"],
      "answer": [0, 1, 2],
      "explanation": "安全带可以在紧急情况下约束驾乘人员，防止前冲，减轻伤害。但对颈部的保护需要配合头枕使用。"
    },
    {
      "id": "demo_003",
      "type": "judge",
      "question": "机动车在高速公路上发生故障时，应当在故障车来车方向150米以外设置警告标志。",
      "options": ["正确", "错误"],
      "answer": [0],
      "explanation": "高速公路上设置警告标志应在来车方向150米以外，这是为了给后方车辆足够的反应距离。"
    }
  ]
}
```

#### 3.3.6 部署方案

**Docker部署**：
```dockerfile
# Dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o quiz-backend .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/quiz-backend .
COPY --from=builder /app/data ./data

EXPOSE 8080
CMD ["./quiz-backend"]
```

**Docker Compose**：
```yaml
# docker-compose.yml
version: '3.8'

services:
  backend:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./data:/root/data
    environment:
      - GIN_MODE=release
    restart: unless-stopped
```

**传统部署**：
```bash
# 编译
go build -o quiz-backend

# 使用systemd管理
# /etc/systemd/system/quiz-backend.service
[Unit]
Description=Quiz Backend Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/quiz-backend
ExecStart=/opt/quiz-backend/quiz-backend
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### 3.4 数据结构设计

#### 3.4.1 题库JSON结构（服务端）
```json
{
  "id": "cn_subject1_v1",
  "name": "中国驾照科目一",
  "version": "1.0.0",
  "description": "中国驾照科目一题库",
  "total_questions": 1500,
  "created_at": "2026-01-01",
  "updated_at": "2026-01-20",
  "language": "zh-CN",
  "questions": [
    {
      "id": "q001",
      "type": "single",
      "question": "驾驶机动车在道路上违反道路交通安全法的行为，属于什么行为？",
      "image": "https://example.com/images/q001.jpg",
      "options": [
        "违章行为",
        "违法行为",
        "过失行为",
        "违规行为"
      ],
      "answer": [1],
      "explanation": "违反道路交通安全法的行为属于违法行为。违法行为是指违反法律规定的行为。",
      "chapter": "道路交通安全法律法规"
    },
    {
      "id": "q002",
      "type": "multiple",
      "question": "以下哪些情况下不得超车？（多选）",
      "options": [
        "前方车辆正在左转弯",
        "前方车辆正在掉头",
        "前方车辆正在超车",
        "通过铁路道口"
      ],
      "answer": [0, 1, 2, 3],
      "explanation": "以上情况均不得超车。"
    },
    {
      "id": "q003",
      "type": "judge",
      "question": "驾驶机动车上路前，驾驶人应当对机动车的安全技术性能进行认真检查。",
      "options": [
        "正确",
        "错误"
      ],
      "answer": [0],
      "explanation": "驾驶人上路前应当对车辆进行安全检查，这是驾驶人的基本责任。"
    }
  ]
}
```

**题目类型说明**：
- `single`：单选题，4个选项，答案为单个索引
- `multiple`：多选题，4个选项，答案为多个索引数组
- `judge`：判断题，2个选项（正确/错误），答案为单个索引

#### 3.4.2 题库列表API响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "question_banks": [
      {
        "id": "cn_subject1_v1",
        "name": "中国驾照科目一",
        "description": "科目一理论考试题库",
        "total_questions": 1500,
        "version": "1.0.0",
        "language": "zh-CN",
        "size": "5.2MB",
        "download_url": "https://example.com/api/banks/cn_subject1_v1/download",
        "updated_at": "2026-01-20"
      },
      {
        "id": "cn_subject4_v1",
        "name": "中国驾照科目四",
        "description": "科目四安全文明驾驶题库",
        "total_questions": 1200,
        "version": "1.0.0",
        "language": "zh-CN",
        "size": "4.8MB",
        "download_url": "https://example.com/api/banks/cn_subject4_v1/download",
        "updated_at": "2026-01-15"
      }
    ]
  }
}
```

#### 3.4.3 移动端本地数据库结构（SQLite）

**题库表（question_banks）**：
```sql
CREATE TABLE question_banks (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    version TEXT,
    total_questions INTEGER,
    language TEXT,
    downloaded_at TIMESTAMP,
    data TEXT -- JSON存储题目数据
);
```

**答题记录表（answer_records）**：
```sql
CREATE TABLE answer_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bank_id TEXT NOT NULL,
    question_id TEXT NOT NULL,
    user_answer TEXT, -- JSON数组存储答案索引
    is_correct BOOLEAN,
    answered_at TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES question_banks(id)
);
```

**题库进度表（bank_progress）**：
```sql
CREATE TABLE bank_progress (
    bank_id TEXT PRIMARY KEY,
    current_index INTEGER DEFAULT 0, -- 顺序模式的当前位置
    total_answered INTEGER DEFAULT 0,
    total_correct INTEGER DEFAULT 0,
    FOREIGN KEY (bank_id) REFERENCES question_banks(id)
);
```

**错题表（wrong_questions）**：
```sql
CREATE TABLE wrong_questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bank_id TEXT NOT NULL,
    question_id TEXT NOT NULL,
    is_mastered BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES question_banks(id),
    UNIQUE(bank_id, question_id)
);
```

**收藏表（favorites）**：
```sql
CREATE TABLE favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bank_id TEXT NOT NULL,
    question_id TEXT NOT NULL,
    created_at TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES question_banks(id),
    UNIQUE(bank_id, question_id)
);
```

---

## 4. 用户体验设计

### 4.1 设计理念与风格

#### 4.1.1 设计愿景
**"轻松、专注、成就感"** —— 让每一次刷题都成为愉悦的学习体验。

#### 4.1.2 设计原则

| 原则 | 说明 | 具体体现 |
|------|------|---------|
| **专注沉浸** | 减少干扰，让用户专注于题目本身 | 卡片式单题展示、简洁的界面、无广告干扰 |
| **即时反馈** | 每个操作都有明确的视觉和触觉反馈 | 答题后立即显示对错、按钮点击动效、震动反馈 |
| **渐进披露** | 根据需要逐步展示信息，避免信息过载 | 答题后才显示解析、模式切换使用底部弹窗 |
| **情感连接** | 通过设计细节传递温度和鼓励 | 答对时的庆祝动画、进度里程碑提示、友好的空状态 |
| **一致性** | 保持视觉和交互的统一性 | 统一的组件风格、一致的动画时长、规范的间距系统 |

#### 4.1.3 视觉风格定位

**风格关键词**：
- 现代简约（Modern Minimal）
- 轻量友好（Light & Friendly）
- 专业可信（Professional & Trustworthy）

**设计参考**：
- 百词斩：卡片式沉浸学习体验
- Duolingo：趣味性与学习结合
- Apple Human Interface：精致的细节处理

**整体视觉特征**：
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │                                                 │   │
│  │      大面积留白 + 居中内容                        │   │
│  │                                                 │   │
│  │      ┌───────────────────────────────────┐     │   │
│  │      │                                   │     │   │
│  │      │     圆润的卡片 + 柔和阴影           │     │   │
│  │      │                                   │     │   │
│  │      │     清晰的层次 + 明确的主次          │     │   │
│  │      │                                   │     │   │
│  │      └───────────────────────────────────┘     │   │
│  │                                                 │   │
│  │      醒目的主色按钮 + 克制的装饰元素            │   │
│  │                                                 │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 4.2 色彩系统

#### 4.2.1 品牌色彩

**主色调（Primary Palette）**：
```
品牌蓝 Blue
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  50  #EFF6FF  ████  极浅蓝，选中背景
 100  #DBEAFE  ████  浅蓝，hover状态
 200  #BFDBFE  ████  
 300  #93C5FD  ████  
 400  #60A5FA  ████  深色模式主色
 500  #3B82F6  ████  【主色】品牌色、按钮、链接
 600  #2563EB  ████  按下状态
 700  #1D4ED8  ████  
 800  #1E40AF  ████  
 900  #1E3A8A  ████  深蓝
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**语义色彩（Semantic Colors）**：
```
成功绿 Green                    错误红 Red
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 50  #F0FDF4  ████  正确背景    50  #FEF2F2  ████  错误背景
500  #22C55E  ████  正确主色   500  #EF4444  ████  错误主色
600  #16A34A  ████  正确强调   600  #DC2626  ████  错误强调
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

收藏橙 Amber                    
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
400  #FBBF24  ████  收藏星标
500  #F59E0B  ████  收藏主色   
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
```

**浅色模式（Light Mode）完整色板**：

| 类别 | Token | 色值 | 用途 |
|------|-------|------|------|
| **品牌** | `--color-primary` | `#3B82F6` | 主按钮、链接、选中态 |
| | `--color-primary-hover` | `#2563EB` | 主按钮悬停 |
| | `--color-primary-pressed` | `#1D4ED8` | 主按钮按下 |
| | `--color-primary-light` | `#DBEAFE` | 选中背景、标签背景 |
| **语义** | `--color-success` | `#22C55E` | 正确反馈 |
| | `--color-success-bg` | `#DCFCE7` | 正确选项背景 |
| | `--color-error` | `#EF4444` | 错误反馈 |
| | `--color-error-bg` | `#FEE2E2` | 错误选项背景 |
| | `--color-warning` | `#F59E0B` | 警告、收藏 |
| **背景** | `--color-bg-page` | `#F8FAFC` | 页面背景 |
| | `--color-bg-card` | `#FFFFFF` | 卡片背景 |
| | `--color-bg-elevated` | `#FFFFFF` | 弹窗背景 |
| | `--color-bg-hover` | `#F1F5F9` | 列表项悬停 |
| **文字** | `--color-text-primary` | `#1E293B` | 标题、主要文字 |
| | `--color-text-secondary` | `#64748B` | 次要文字、说明 |
| | `--color-text-tertiary` | `#94A3B8` | 占位符、禁用态 |
| | `--color-text-inverse` | `#FFFFFF` | 深色背景上的文字 |
| **边框** | `--color-border` | `#E2E8F0` | 默认边框 |
| | `--color-divider` | `#F1F5F9` | 分割线 |

**深色模式（Dark Mode）完整色板**：

| 类别 | Token | 色值 | 用途 |
|------|-------|------|------|
| **品牌** | `--color-primary` | `#60A5FA` | 主按钮、链接 |
| | `--color-primary-hover` | `#3B82F6` | 主按钮悬停 |
| | `--color-primary-pressed` | `#2563EB` | 主按钮按下 |
| | `--color-primary-light` | `#1E3A5F` | 选中背景 |
| **语义** | `--color-success` | `#4ADE80` | 正确反馈 |
| | `--color-success-bg` | `#14532D` | 正确选项背景 |
| | `--color-error` | `#F87171` | 错误反馈 |
| | `--color-error-bg` | `#7F1D1D` | 错误选项背景 |
| | `--color-warning` | `#FBBF24` | 警告、收藏 |
| **背景** | `--color-bg-page` | `#0F172A` | 页面背景 |
| | `--color-bg-card` | `#1E293B` | 卡片背景 |
| | `--color-bg-elevated` | `#334155` | 弹窗背景 |
| | `--color-bg-hover` | `#334155` | 列表项悬停 |
| **文字** | `--color-text-primary` | `#F1F5F9` | 标题、主要文字 |
| | `--color-text-secondary` | `#94A3B8` | 次要文字 |
| | `--color-text-tertiary` | `#64748B` | 占位符 |
| | `--color-text-inverse` | `#0F172A` | 浅色背景上的文字 |
| **边框** | `--color-border` | `#334155` | 默认边框 |
| | `--color-divider` | `#1E293B` | 分割线 |

#### 4.2.2 渐变色

**品牌渐变（用于启动页、特殊卡片）**：
```css
/* 主渐变 */
background: linear-gradient(135deg, #3B82F6 0%, #1D4ED8 100%);

/* 成功渐变 */
background: linear-gradient(135deg, #22C55E 0%, #16A34A 100%);

/* 温暖渐变（用于成就、里程碑）*/
background: linear-gradient(135deg, #F59E0B 0%, #EA580C 100%);
```

#### 4.2.3 色彩使用指南

**选项卡片状态变化**：
```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  默认态           选中态           正确态           错误态       │
│  ┌────────┐     ┌────────┐     ┌────────┐     ┌────────┐      │
│  │        │     │ ▋      │     │ ▋  ✓   │     │ ▋  ✗   │      │
│  │ A 选项 │     │ A 选项 │     │ A 选项 │     │ A 选项 │      │
│  │        │     │        │     │        │     │        │      │
│  └────────┘     └────────┘     └────────┘     └────────┘      │
│                                                                 │
│  边框：灰       边框：蓝       背景：浅绿      背景：浅红       │
│  #E2E8F0       #3B82F6       #DCFCE7       #FEE2E2           │
│                左侧蓝条       左侧绿条       左侧红条          │
│                              文字：深绿      文字：深红        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.3 排版系统

#### 4.3.1 字体家族

**系统字体栈**：
```dart
// Flutter 字体配置
fontFamily: Platform.isIOS 
  ? '.SF Pro Text'  // iOS
  : 'Roboto',       // Android

// 中文字体回退
fontFamilyFallback: [
  'PingFang SC',    // iOS 中文
  'Noto Sans CJK',  // Android 中文
  'sans-serif',
],
```

#### 4.3.2 字号层级

**Type Scale（基于 4dp 网格）**：
```
Display Large   32sp  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  完成庆祝标题
Display Medium  28sp  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━      里程碑数字
Headline Large  24sp  ━━━━━━━━━━━━━━━━━━━━━━━━          页面大标题
Headline Medium 20sp  ━━━━━━━━━━━━━━━━━━━━              区块标题
Title Large     18sp  ━━━━━━━━━━━━━━━━━━                题目文字
Title Medium    16sp  ━━━━━━━━━━━━━━━━                  选项文字、按钮
Body Large      16sp  ━━━━━━━━━━━━━━━━                  正文
Body Medium     15sp  ━━━━━━━━━━━━━━                    解析文字
Body Small      14sp  ━━━━━━━━━━━━━━                    辅助说明
Label Large     14sp  ━━━━━━━━━━━━━━                    标签、徽章
Label Medium    12sp  ━━━━━━━━━━━━                      小标签
Label Small     11sp  ━━━━━━━━━━                        极小提示
```

**完整字号规范表**：

| Token | 字号 | 字重 | 行高 | 字间距 | 用途 |
|-------|------|------|------|--------|------|
| `displayLarge` | 32sp | Bold | 40dp | -0.5px | 完成庆祝 |
| `displayMedium` | 28sp | Bold | 36dp | 0 | 大数字展示 |
| `headlineLarge` | 24sp | SemiBold | 32dp | 0 | 页面标题 |
| `headlineMedium` | 20sp | SemiBold | 28dp | 0 | 区块标题 |
| `titleLarge` | 18sp | Medium | 28dp | 0.15px | 题目内容 |
| `titleMedium` | 16sp | Medium | 24dp | 0.15px | 选项、按钮 |
| `bodyLarge` | 16sp | Regular | 26dp | 0.5px | 正文 |
| `bodyMedium` | 15sp | Regular | 24dp | 0.25px | 解析 |
| `bodySmall` | 14sp | Regular | 20dp | 0.4px | 辅助说明 |
| `labelLarge` | 14sp | Medium | 20dp | 0.1px | 按钮文字 |
| `labelMedium` | 12sp | Medium | 16dp | 0.5px | 标签 |
| `labelSmall` | 11sp | Medium | 16dp | 0.5px | 极小文字 |

#### 4.3.3 字重使用

| 字重 | 数值 | 用途 |
|------|------|------|
| **Regular** | 400 | 正文、选项、解析 |
| **Medium** | 500 | 题目、按钮文字、标签 |
| **SemiBold** | 600 | 区块标题 |
| **Bold** | 700 | 页面标题、大数字 |

### 4.4 间距与网格

#### 4.4.1 间距系统（4dp Base）

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Token      Size    Visual                  用途
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 space-0    0dp     无                      无间距
 space-1    4dp     ▌                       极小间距（图标与文字）
 space-2    8dp     ██                      紧凑间距（内边距）
 space-3    12dp    ███                     小间距
 space-4    16dp    ████                    【默认】标准间距
 space-5    20dp    █████                   中等间距
 space-6    24dp    ██████                  区块间距
 space-8    32dp    ████████                大区块间距
 space-10   40dp    ██████████              超大间距
 space-12   48dp    ████████████            页面级间距
 space-16   64dp    ████████████████        特殊场景
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 4.4.2 页面布局间距

```
┌─────────────────────────────────────────────────────────────┐
│                        ←  16dp  →                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    状态栏区域                          │  │
│  └───────────────────────────────────────────────────────┘  │
│                         ↕ 8dp                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    导航栏 56dp                         │  │
│  └───────────────────────────────────────────────────────┘  │
│                         ↕ 16dp                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                                                       │  │
│  │                    内容区域                            │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  卡片内边距 16dp                                 │  │  │
│  │  │                                                 │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                                                       │  │
│  │                    ↕ 卡片间距 12dp                     │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │                                                 │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                                                       │  │
│  └───────────────────────────────────────────────────────┘  │
│                         ↕ 16dp                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                   底部操作栏                           │  │
│  └───────────────────────────────────────────────────────┘  │
│                     ↕ 安全区域                              │
└─────────────────────────────────────────────────────────────┘
```

### 4.5 圆角与阴影

#### 4.5.1 圆角系统

| Token | 数值 | 用途 |
|-------|------|------|
| `radius-none` | 0dp | 无圆角 |
| `radius-xs` | 4dp | 小元素（进度条、标签） |
| `radius-sm` | 6dp | 小按钮、输入框 |
| `radius-md` | 8dp | 按钮、选项卡片 |
| `radius-lg` | 12dp | 卡片、对话框 |
| `radius-xl` | 16dp | 底部弹窗 |
| `radius-2xl` | 20dp | 大卡片 |
| `radius-full` | 9999dp | 圆形（头像、胶囊按钮） |

#### 4.5.2 阴影层级

**浅色模式**：
```css
/* Level 1 - 卡片阴影 */
shadow-sm: 0 1dp 2dp rgba(0, 0, 0, 0.05);

/* Level 2 - 悬浮卡片 */
shadow-md: 0 4dp 6dp rgba(0, 0, 0, 0.07), 
           0 2dp 4dp rgba(0, 0, 0, 0.06);

/* Level 3 - 弹窗、下拉菜单 */
shadow-lg: 0 10dp 15dp rgba(0, 0, 0, 0.10),
           0 4dp 6dp rgba(0, 0, 0, 0.05);

/* Level 4 - 模态框 */
shadow-xl: 0 20dp 25dp rgba(0, 0, 0, 0.15),
           0 10dp 10dp rgba(0, 0, 0, 0.04);
```

**深色模式**：
- 阴影透明度降低 50%
- 增加微弱边框以增强层次感
```css
shadow-md: 0 4dp 6dp rgba(0, 0, 0, 0.3);
border: 1dp solid rgba(255, 255, 255, 0.05);
```

### 4.6 动效设计

#### 4.6.1 动效原则

| 原则 | 说明 |
|------|------|
| **有意义** | 动效服务于功能，而非装饰 |
| **快速** | 不让用户等待，最长不超过400ms |
| **自然** | 遵循物理规律，符合用户直觉 |
| **一致** | 相同类型的操作使用相同的动效 |

#### 4.6.2 时长规范

| 类型 | 时长 | 曲线 | 场景 |
|------|------|------|------|
| **即时反馈** | 100ms | ease-out | 按钮点击、选项选中 |
| **快速过渡** | 200ms | ease-out | 颜色变化、透明度 |
| **标准过渡** | 300ms | ease-in-out | 页面切换、卡片滑动 |
| **复杂动画** | 400ms | spring | 弹窗出现、庆祝动画 |
| **强调动画** | 500-800ms | spring | 完成庆祝、里程碑 |

#### 4.6.3 缓动曲线

```dart
// Flutter Curves
const standardEasing = Curves.easeInOut;
const emphasizedEasing = Curves.easeOutCubic;
const decelerateEasing = Curves.decelerate;

// 弹性动画
const springCurve = SpringDescription(
  mass: 1,
  stiffness: 300,
  damping: 20,
);
```

#### 4.6.4 核心动效设计

**① 卡片切换动效**：
```
┌────────────────────────────────────────────────────────────┐
│  向左滑动 → 下一题                                          │
│                                                            │
│  当前卡片                 下一张卡片                        │
│  ┌──────────┐            ┌──────────┐                      │
│  │   Q1     │  ────→     │   Q2     │                      │
│  │          │  fade out  │          │  fade in + slide     │
│  └──────────┘            └──────────┘                      │
│                                                            │
│  动画参数：                                                 │
│  - 时长：300ms                                              │
│  - 位移：屏幕宽度 × 30%                                      │
│  - 透明度：1.0 → 0.0 / 0.0 → 1.0                            │
│  - 缩放：1.0 → 0.95 / 0.95 → 1.0                            │
│  - 曲线：easeInOut                                          │
└────────────────────────────────────────────────────────────┘
```

**② 选项选中动效**：
```
┌────────────────────────────────────────────────────────────┐
│  点击选项 A                                                 │
│                                                            │
│  未选中态          →        选中态                          │
│  ┌────────────┐         ┌────────────┐                     │
│  │ ○ A. xxx   │  100ms  │ ● A. xxx   │                     │
│  └────────────┘         └────────────┘                     │
│                              ↓                              │
│  动画效果：                   ↓  200ms                      │
│  1. 圆圈填充动画（100ms）     ↓                              │
│  2. 边框变蓝（100ms）        ↓                              │
│  3. 轻微缩放 0.98→1.0       ↓                              │
│  4. 触觉反馈（轻震）         ↓                              │
│                              ↓                              │
│                         ┌────────────┐                     │
│  答对                   │ ● A. xxx ✓ │   背景渐变绿        │
│                         └────────────┘                     │
│  答错                   │ ● A. xxx ✗ │   背景渐变红        │
│                         └────────────┘   + 抖动动画        │
└────────────────────────────────────────────────────────────┘
```

**③ 答题反馈动效**：

**答对反馈**：
```
时间轴 (ms)：  0     100    200    300    400    500
              │      │      │      │      │      │
选项背景：    ─────────▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
              默认色    渐变为浅绿色
              
对勾图标：           ──────▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
                     scale: 0→1.2→1.0 (弹性)
                     
震动反馈：           ▌
                    轻震（success haptic）
```

**答错反馈**：
```
时间轴 (ms)：  0     100    200    300    400
              │      │      │      │      │
选项背景：    ─────────▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
              默认色    渐变为浅红色
              
错叉图标：           ──────▓▓▓▓▓▓▓▓▓▓▓▓
                     scale: 0→1.0
                     
卡片抖动：           ←→←→←→
                     水平位移：-8dp→8dp→-4dp→4dp→0
                     
震动反馈：           ▌▌▌
                    三次短震（error haptic）
```

**④ 收藏动效**：
```
点击收藏星标：
┌──────────────────────────────────────┐
│                                      │
│      ☆ (白色)     →     ★ (黄色)     │
│                                      │
│  动画序列：                           │
│  1. 缩放：1.0 → 0.8 (100ms)          │
│  2. 缩放：0.8 → 1.3 (150ms)          │
│  3. 缩放：1.3 → 1.0 (100ms)          │
│  4. 颜色：白 → 黄 (同步)              │
│  5. 可选：粒子爆炸效果               │
│                                      │
└──────────────────────────────────────┘
```

**⑤ 完成庆祝动效**：
```
刷完全部题目时：
┌────────────────────────────────────────────────────────────┐
│                                                            │
│                      🎉                                    │
│                                                            │
│                   恭喜完成！                                │
│                                                            │
│              已完成全部 1500 道题目                         │
│                                                            │
│  动画效果：                                                 │
│  1. 背景模糊 + 遮罩渐显 (200ms)                             │
│  2. 卡片从下方滑入 (300ms, spring)                          │
│  3. 庆祝图标放大弹跳 (400ms)                                │
│  4. 数字滚动动画 (500ms)                                    │
│  5. 顶部撒花/彩带粒子 (持续 2s)                             │
│  6. 触觉反馈：success notification                         │
│                                                            │
│        [从头再刷]         [返回题库]                        │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

#### 4.6.5 页面转场动效

| 转场类型 | 动画效果 | 时长 |
|---------|---------|------|
| **Push（进入子页面）** | 新页面从右滑入，旧页面左移淡出 | 300ms |
| **Pop（返回上级）** | 当前页面右滑淡出，旧页面从左显现 | 250ms |
| **Modal（弹窗）** | 底部滑入 + 背景模糊 | 300ms |
| **Fade（淡入淡出）** | 透明度变化 | 200ms |

### 4.7 触觉反馈（Haptic Feedback）

#### 4.7.1 反馈类型

| 类型 | iOS | Android | 使用场景 |
|------|-----|---------|---------|
| **轻触** | `light` | `HapticFeedbackConstants.KEYBOARD_TAP` | 选项选中、按钮点击 |
| **中等** | `medium` | `HapticFeedbackConstants.VIRTUAL_KEY` | 重要操作确认 |
| **成功** | `success` | `HapticFeedbackConstants.CONFIRM` | 答对、收藏成功 |
| **警告** | `warning` | `HapticFeedbackConstants.REJECT` | 答错第一次 |
| **错误** | `error` | `HapticFeedbackConstants.LONG_PRESS` | 答错、操作失败 |

#### 4.7.2 反馈场景

| 场景 | 反馈类型 | 说明 |
|------|---------|------|
| 选中选项 | 轻触 | 即时反馈，告知用户选中成功 |
| 提交答案 | 中等 | 强调操作确认 |
| 答对 | 成功 | 正向激励 |
| 答错 | 错误 × 2 | 连续两次短震，加深印象 |
| 收藏/取消收藏 | 轻触 | 状态切换反馈 |
| 标记已掌握 | 成功 | 正向操作 |
| 滑动切题 | 轻触 | 滑动到阈值时触发 |
| 长按菜单 | 中等 | 确认进入长按状态 |

### 4.8 组件设计规范

#### 4.8.1 按钮组件

**主要按钮（Primary Button）**：
```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   默认态          悬停态          按下态          禁用态         │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐     │
│  │  确 认  │    │  确 认  │    │  确 认  │    │  确 认  │     │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘     │
│                                                                 │
│  背景：#3B82F6   背景：#2563EB   背景：#1D4ED8   背景：#94A3B8  │
│  文字：#FFFFFF   文字：#FFFFFF   文字：#FFFFFF   文字：#FFFFFF  │
│  圆角：8dp       缩放：1.0       缩放：0.98     透明度：1.0     │
│                                                                 │
│  尺寸：高度 48dp，最小宽度 88dp，水平内边距 24dp                 │
│  字体：labelLarge (14sp Medium)                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**次要按钮（Secondary Button）**：
```
边框样式：1dp solid #3B82F6，背景透明，文字 #3B82F6
```

**文字按钮（Text Button）**：
```
无边框无背景，仅文字 #3B82F6，点击态降低透明度
```

**图标按钮（Icon Button）**：
```
尺寸：44dp × 44dp（点击区域），图标 24dp
```

**按钮状态变化**：
```dart
// 按下态动画
Transform.scale(
  scale: isPressed ? 0.98 : 1.0,
  duration: 100ms,
)
```

#### 4.8.2 选项卡片组件

**单选/判断题选项**：
```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  默认态                                                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  ○  A. 违章行为                                        │ │
│  └────────────────────────────────────────────────────────┘ │
│  背景：#FFFFFF  边框：1dp #E2E8F0  圆角：8dp                 │
│                                                              │
│  选中态                                                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │▌ ●  A. 违章行为                                        │ │
│  └────────────────────────────────────────────────────────┘ │
│  背景：#FFFFFF  边框：1dp #3B82F6  左侧条：3dp #3B82F6      │
│                                                              │
│  正确态                                                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │▌ ●  A. 违章行为                               ✓        │ │
│  └────────────────────────────────────────────────────────┘ │
│  背景：#DCFCE7  边框：1dp #22C55E  左侧条：3dp #22C55E      │
│  图标：#22C55E                                               │
│                                                              │
│  错误态（用户选中但答错）                                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │▌ ●  A. 违章行为                               ✗        │ │
│  └────────────────────────────────────────────────────────┘ │
│  背景：#FEE2E2  边框：1dp #EF4444  左侧条：3dp #EF4444      │
│  图标：#EF4444                                               │
│                                                              │
│  正确答案提示（用户未选但这是正确答案）                        │
│  ┌────────────────────────────────────────────────────────┐ │
│  │▌ ○  B. 违法行为                               ✓        │ │
│  └────────────────────────────────────────────────────────┘ │
│  背景：#DCFCE7  边框：1dp #22C55E  高亮显示正确答案          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**多选题选项**：
```
用复选框 ☐/☑ 替代单选圆圈 ○/●
其他样式相同
```

#### 4.8.3 题目卡片组件

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  ┌────────┐                                              │  │
│  │  │ 单选题 │  ← 题目类型标签（可选）                        │  │
│  │  └────────┘                                              │  │
│  │                                      ↕ 12dp              │  │
│  │  驾驶机动车在道路上违反道路交通安全法                     │  │
│  │  的行为，属于什么行为？                                  │  │
│  │                                      ↕ 16dp              │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │                                                  │   │  │
│  │  │              [题目配图区域]                       │   │  │
│  │  │              可选，最大高度 200dp                 │   │  │
│  │  │              圆角 8dp                            │   │  │
│  │  │                                                  │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  卡片样式：                                                    │
│  - 背景：#FFFFFF（浅色）/ #1E293B（深色）                       │
│  - 圆角：12dp                                                  │
│  - 阴影：shadow-md                                             │
│  - 内边距：20dp                                                │
│  - 题目字体：titleLarge (18sp Medium)                          │
│  - 行高：1.6                                                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

#### 4.8.4 解析卡片组件

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  答题后展开显示                                                │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  📖 答案解析                          ← 标题 + 图标      │  │
│  │  ────────────────────────────────                        │  │
│  │                                                          │  │
│  │  违反道路交通安全法的行为属于违法行为。                   │  │
│  │  违法行为是指违反法律规定的行为。                        │  │
│  │                                                          │  │
│  │  根据《道路交通安全法》第九十条规定...                    │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  样式：                                                        │
│  - 背景：#F8FAFC（浅色）/ #0F172A（深色）                       │
│  - 圆角：12dp                                                  │
│  - 内边距：16dp                                                │
│  - 标题：bodyMedium (15sp Medium) + 图标 16dp                  │
│  - 正文：bodyMedium (15sp Regular)                             │
│  - 文字颜色：text-secondary                                    │
│  - 入场动画：fade in + slide up (200ms)                        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

#### 4.8.5 进度指示器

**线性进度条**：
```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  高度：4dp                                                     │
│  圆角：2dp                                                     │
│  背景：#E2E8F0                                                 │
│  进度：#3B82F6（渐变效果可选）                                  │
│  动画：进度变化时 300ms ease-out                               │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

**环形进度（统计页面）**：
```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    ╭───────────╮                               │
│                   ╱             ╲                              │
│                  │    78%      │                              │
│                  │   正确率     │                              │
│                   ╲             ╱                              │
│                    ╰───────────╯                               │
│                                                                │
│  外圈：进度色 #3B82F6                                           │
│  内圈背景：#E2E8F0                                              │
│  中心数字：displayMedium (28sp Bold)                           │
│  动画：数字递增 + 环形填充 (500ms)                              │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

#### 4.8.6 题库卡片组件

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  📚 科目一理论题库                          [有更新]     │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │█████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░│  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  已刷 750 / 1500 题                        正确率 85%   │  │
│  │                                                          │  │
│  │  错题 32    收藏 15                                      │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  交互：                                                        │
│  - 点击：进入刷题                                              │
│  - 长按：弹出菜单（重置进度/删除）                              │
│  - 左滑：显示删除按钮                                          │
│                                                                │
│  样式：                                                        │
│  - 卡片圆角：12dp                                              │
│  - 阴影：shadow-md                                             │
│  - 悬停：阴影加深                                              │
│  - "有更新"标签：右上角小徽章，橙色 #F59E0B                     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

#### 4.8.7 底部弹窗组件

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  ░░░░░░░░░░░░░░░░ 背景遮罩 40% 黑 ░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    ─────                                 │  │
│  │                  (拖拽指示条)                             │  │
│  │                                                          │  │
│  │  选择刷题模式                                            │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  📋  顺序模式                               ✓      │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  🎲  随机模式                                      │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ❌  错题模式                           32题       │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ⭐  收藏模式                           15题       │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                          │  │
│  │                    安全区域                              │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  样式：                                                        │
│  - 顶部圆角：16dp                                              │
│  - 拖拽条：40dp × 4dp，圆角 2dp，#CBD5E1                       │
│  - 入场动画：底部滑入 (300ms, spring)                          │
│  - 退出动画：底部滑出 (250ms, ease-in)                         │
│  - 点击遮罩关闭                                                │
│  - 支持手势下拉关闭                                            │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 4.9 图标与插图

#### 4.9.1 图标风格

**图标规范**：
- 风格：线性图标（Outlined），线宽 1.5dp
- 尺寸：24dp（标准）、20dp（小）、28dp（大）
- 颜色：继承文字颜色，或使用语义色
- 来源推荐：Lucide Icons / Phosphor Icons / SF Symbols

**核心图标清单**：

| 图标 | 用途 | 建议 |
|------|------|------|
| `book-open` | 题库 | 📖 |
| `check-circle` | 正确 | ✓ |
| `x-circle` | 错误 | ✗ |
| `star` | 收藏 | ⭐ |
| `shuffle` | 随机模式 | 🎲 |
| `list-ordered` | 顺序模式 | 📋 |
| `alert-circle` | 错题 | ⚠️ |
| `bar-chart-2` | 统计 | 📊 |
| `settings` | 设置 | ⚙️ |
| `download` | 下载 | ⬇️ |
| `trash-2` | 删除 | 🗑️ |
| `refresh-cw` | 刷新/重试 | 🔄 |
| `chevron-left` | 返回 | ← |
| `chevron-right` | 下一步 | → |
| `check` | 已掌握 | ✔️ |
| `moon` | 深色模式 | 🌙 |
| `sun` | 浅色模式 | ☀️ |
| `globe` | 语言 | 🌐 |

#### 4.9.2 插图风格

**空状态插图**：
- 风格：扁平插画，简洁可爱
- 尺寸：160dp × 120dp
- 配色：使用品牌蓝 + 中性灰，少量点缀色
- 情感：友好、鼓励、不消极

**插图示例描述**：

| 场景 | 插图描述 |
|------|---------|
| **错题本为空** | 一个笑脸奖杯或星星，传达"太棒了，没有错题" |
| **收藏夹为空** | 一颗等待被点亮的星星 |
| **网络错误** | 一朵断开的云，表情略显困惑 |
| **完成庆祝** | 彩带、气球、奖杯组合 |
| **加载中** | 汽车行驶动画或转动的方向盘 |

### 4.10 情感化设计

#### 4.10.1 激励与成就感

**进度里程碑提示**：
```
当用户完成特定进度时，显示鼓励弹窗：

┌────────────────────────────────────────┐
│                                        │
│              🎯                       │
│                                        │
│         太棒了！                       │
│                                        │
│   您已完成 25% 的题目                  │
│   继续加油！                           │
│                                        │
│           [继续刷题]                   │
│                                        │
└────────────────────────────────────────┘

触发点：25%、50%、75%、100%
```

**连续答对激励**：
```
连续答对 5/10/20 题时：

┌────────────────────────────────────────┐
│                                        │
│           🔥 连对 10 题！              │
│                                        │
│           保持手感！                   │
│                                        │
└────────────────────────────────────────┘

显示方式：顶部 Toast，2秒后自动消失
```

#### 4.10.2 友好的错误处理

**错误信息设计原则**：
- 使用友好、非技术性的语言
- 提供明确的解决方案
- 避免责怪用户

| 场景 | 错误文案 | 操作 |
|------|---------|------|
| 网络超时 | "网络似乎不太稳定，请检查后重试" | [重试] |
| 下载失败 | "下载遇到问题了，再试一次？" | [重试] |
| 存储不足 | "设备存储空间不足，清理后再下载吧" | [确定] |
| 数据加载失败 | "加载数据时出了点问题" | [重试] |

#### 4.10.3 微文案（Microcopy）

**按钮文案**：
| 场景 | 文案 | 说明 |
|------|------|------|
| 提交答案 | 确认 | 简洁明确 |
| 进入下一题 | 下一题 | 而非"继续" |
| 完成后重新开始 | 从头再刷 | 亲切口语化 |
| 删除题库 | 删除 | 配合确认弹窗 |
| 错题标记完成 | 已掌握 | 正向表达 |
| 空状态 | 暂无错题，继续保持！ | 鼓励性 |

**进度文案**：
```
刷题进度：已刷 125 / 1500 题
正确率：正确率 85%
错题数：错题 32 道
```

### 4.11 无障碍设计（Accessibility）

#### 4.11.1 视觉无障碍

| 要求 | 实现 |
|------|------|
| **颜色对比度** | 所有文字与背景对比度 ≥ 4.5:1（WCAG AA） |
| **不仅依赖颜色** | 正确/错误除颜色外，还有图标✓/✗区分 |
| **字号可调** | 支持系统字号设置，界面自适应 |
| **深色模式** | 完整支持，减少眼睛疲劳 |

#### 4.11.2 交互无障碍

| 要求 | 实现 |
|------|------|
| **点击区域** | 所有可点击元素 ≥ 44dp × 44dp |
| **屏幕阅读器** | 所有元素添加语义化标签 |
| **焦点指示** | 键盘导航时有明显的焦点框 |
| **操作确认** | 危险操作（删除、重置）需二次确认 |

#### 4.11.3 屏幕阅读器标签

```dart
// 示例：选项按钮
Semantics(
  label: '选项A：违法行为',
  hint: isSelected ? '已选中' : '点击选择',
  button: true,
  child: OptionCard(...),
)

// 示例：收藏按钮
Semantics(
  label: isFavorite ? '取消收藏' : '添加收藏',
  button: true,
  child: FavoriteButton(...),
)

// 示例：进度
Semantics(
  label: '当前进度：第125题，共1500题',
  child: ProgressIndicator(...),
)
```

### 4.12 App图标与启动页

#### 4.12.1 App图标设计
**设计要素**：
- 主体：简化的汽车/方向盘图形 + 对勾符号
- 配色：品牌蓝（`#3B82F6`）为主色
- 风格：扁平化、现代感、易识别
- 背景：白色或浅蓝渐变

**尺寸要求**：
- iOS：1024x1024px（App Store）+ 各尺寸图标
- Android：512x512px（Play Store）+ 自适应图标

#### 4.12.2 启动页（Splash Screen）
**设计要素**：
- 居中显示App图标
- 图标下方显示产品名称"驾考刷刷"
- 底部可显示版本号（可选）
- 背景色：品牌蓝或白色
- 显示时长：1-2秒

### 4.13 交互流程设计

#### 4.13.1 首次使用流程
```
安装App → 启动页 → 直接进入题库列表（含内置Demo题库）
→ 点击内置题库 → 开始刷题
```

#### 4.13.2 答题流程
```
进入题库 → 显示题目 → 选择答案 → 提交 
→ 显示结果和解析 → 点击/滑动下一题 → 显示下一题目
```

#### 4.13.3 模式切换流程
```
点击"模式"按钮 → 弹出模式菜单 → 选择模式 
→ 切换到新模式的第一题（或上次位置）
```

#### 4.13.4 题库管理流程
```
打开应用 → 题库列表 → 点击下载 → 显示进度 
→ 下载完成 → 点击进入 → 开始刷题
```

### 4.14 空状态与错误状态设计

#### 4.14.1 空状态页面

**错题本为空**：
```
+----------------------------------+
|                                  |
|          [空状态插图]             |
|                                  |
|      暂无错题                     |
|                                  |
|   继续刷题，错题会自动收录到这里    |
|                                  |
|        [返回继续刷题]             |
|                                  |
+----------------------------------+
```

**收藏夹为空**：
```
+----------------------------------+
|                                  |
|          [空状态插图]             |
|                                  |
|      暂无收藏                     |
|                                  |
|   刷题时点击星标可以收藏题目       |
|                                  |
|        [返回继续刷题]             |
|                                  |
+----------------------------------+
```

**可下载题库为空**：
```
+----------------------------------+
|                                  |
|          [空状态插图]             |
|                                  |
|      暂无可下载的题库             |
|                                  |
|         [点击刷新]               |
|                                  |
+----------------------------------+
```

#### 4.14.2 错误状态页面

**网络错误**：
```
+----------------------------------+
|                                  |
|          [网络错误插图]           |
|                                  |
|      网络连接失败                 |
|                                  |
|   请检查网络设置后重试            |
|                                  |
|          [重试]                  |
|                                  |
+----------------------------------+
```

**题库加载失败**：
```
+----------------------------------+
|                                  |
|          [加载失败插图]           |
|                                  |
|      题库加载失败                 |
|                                  |
|   数据可能已损坏，请重新下载       |
|                                  |
|    [删除并重新下载]  [返回]       |
|                                  |
+----------------------------------+
```

**存储空间不足**（弹窗）：
```
+----------------------------------+
|                                  |
|      存储空间不足                 |
|                                  |
|   设备存储空间不足，无法下载题库。 |
|   请清理设备空间后重试。          |
|                                  |
|            [确定]                |
|                                  |
+----------------------------------+
```

#### 4.14.3 图片加载失败
- 题目图片加载失败时，不显示图片区域
- 题目卡片自动调整高度，只显示文字内容

### 4.15 核心页面详细设计

#### 4.15.1 题库列表页（首页）

```
┌────────────────────────────────────────────────────────────────┐
│ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│ ┃                     状态栏                              ┃  │
│ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │   驾考刷刷                                    ⚙️         │  │
│  │                                             (设置)       │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  我的题库                                    共 2 个     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  📚 示例题库 (Demo)                                      │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │█████████████████████████████████░░░░░░░░░░░░░░░░░│  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  已刷 35 / 50 题                          正确率 88%    │  │
│  │                                                          │  │
│  │  ❌ 错题 4      ⭐ 收藏 2                               │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           ↕ 12dp                               │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  📚 科目一理论                              🔄 有更新    │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │███████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  已刷 450 / 1500 题                       正确率 82%    │  │
│  │                                                          │  │
│  │  ❌ 错题 28     ⭐ 收藏 12                              │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  更多题库                                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  📚 科目四安全文明                           ⬇️ 4.8MB   │  │
│  │                                                          │  │
│  │     1200 道题                                            │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃                     安全区域                            ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
└────────────────────────────────────────────────────────────────┘
```

#### 4.15.2 刷题页面

```
┌────────────────────────────────────────────────────────────────┐
│ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│ ┃                     状态栏                              ┃  │
│ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ←  科目一理论                             📊  顺序     │  │
│  │ (返回)                                   (统计) (模式)  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    125 / 1500                            │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  ┌────────┐                                              │  │
│  │  │ 单选题 │                                              │  │
│  │  └────────┘                                              │  │
│  │                                                          │  │
│  │  驾驶机动车在道路上违反道路交通安全法                     │  │
│  │  的行为，属于什么行为？                                  │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │                                                    │  │  │
│  │  │                   [题目配图]                        │  │  │
│  │  │                                                    │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ○  A. 违章行为                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           ↕ 8dp                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │▌ ●  B. 违法行为                               ✓         │  │
│  └──────────────────────────────────────────────────────────┘  │
│  （答对后变绿，显示对勾）                                      │
│                           ↕ 8dp                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ○  C. 过失行为                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           ↕ 8dp                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ○  D. 违规行为                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  📖 答案解析                                             │  │
│  │  ───────────────────────────────────────────────────     │  │
│  │  违反道路交通安全法的行为属于违法行为。                   │  │
│  │  违法行为是指违反法律规定的行为。                        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │    ←          跳过          下一题 →          ⭐        │  │
│  │  (上一题)                                    (收藏)      │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃                     安全区域                            ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
└────────────────────────────────────────────────────────────────┘
```

#### 4.15.3 统计页面

```
┌────────────────────────────────────────────────────────────────┐
│ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│ ┃                     状态栏                              ┃  │
│ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ←  学习统计                                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │                    ╭───────────╮                         │  │
│  │                   ╱             ╲                        │  │
│  │                  │              │                        │  │
│  │                  │    82%      │                        │  │
│  │                  │   正确率     │                        │  │
│  │                  │              │                        │  │
│  │                   ╲             ╱                        │  │
│  │                    ╰───────────╯                         │  │
│  │                                                          │  │
│  │            科目一理论 · 共 1500 题                       │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │   ┌─────────┐   ┌─────────┐   ┌─────────┐               │  │
│  │   │  450    │   │  1050   │   │  369    │               │  │
│  │   │ 已刷题  │   │ 未刷题  │   │  答对   │               │  │
│  │   └─────────┘   └─────────┘   └─────────┘               │  │
│  │                                                          │  │
│  │   ┌─────────┐   ┌─────────┐   ┌─────────┐               │  │
│  │   │   81    │   │   28    │   │   12    │               │  │
│  │   │  答错   │   │  错题   │   │  收藏   │               │  │
│  │   └─────────┘   └─────────┘   └─────────┘               │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  最近答题趋势                                            │  │
│  │                                                          │  │
│  │        ●                                                 │  │
│  │    ●       ●   ●                                         │  │
│  │  ●           ●   ●  ●                                    │  │
│  │  ─────────────────────                                   │  │
│  │  周一 周二 周三 周四 周五 周六 周日                       │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃                     安全区域                            ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
└────────────────────────────────────────────────────────────────┘
```

#### 4.15.4 设置页面

```
┌────────────────────────────────────────────────────────────────┐
│ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│ ┃                     状态栏                              ┃  │
│ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ←  设置                                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  外观                                                    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  🌙  深色模式                                   [开关]   │  │
│  │  ──────────────────────────────────────────────────────  │  │
│  │  🌐  语言 / Language                          中文 >    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  数据管理                                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  🗑️  清除所有数据                                    >   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  关于                                                    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ℹ️  关于驾考刷刷                                    >   │  │
│  │  ──────────────────────────────────────────────────────  │  │
│  │  📄  隐私政策                                        >   │  │
│  │  ──────────────────────────────────────────────────────  │  │
│  │  ⭐  给我们评分                                      >   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│                                                                │
│                                                                │
│                      版本 1.0.0 (100)                          │
│                                                                │
│                                                                │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃                     安全区域                            ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
└────────────────────────────────────────────────────────────────┘
```

---

## 5. 页面流程图

### 5.1 整体导航结构
```
┌─────────────────────────────────────────────────────────────┐
│                         App启动                             │
│                            ↓                                │
│                       [启动页]                              │
│                            ↓                                │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │                    题库列表页（首页）                    │ │
│ │  ┌──────────┐  ┌──────────┐  ┌──────────┐            │ │
│ │  │已下载题库 │  │可下载题库 │  │  设置    │            │ │
│ │  └────┬─────┘  └────┬─────┘  └────┬─────┘            │ │
│ └───────┼─────────────┼─────────────┼──────────────────┘ │
│         ↓             ↓             ↓                      │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐                │
│   │ 刷题页面 │   │下载进度 │   │ 设置页面 │                │
│   └────┬────┘   └─────────┘   │         │                │
│        │                      │ • 语言   │                │
│        ↓                      │ • 关于   │                │
│   ┌─────────┐                 │ • 清除   │                │
│   │模式切换  │                 └─────────┘                │
│   │• 顺序   │                                             │
│   │• 随机   │                                             │
│   │• 错题   │                                             │
│   │• 收藏   │                                             │
│   └────┬────┘                                             │
│        ↓                                                   │
│   ┌─────────┐                                             │
│   │统计页面  │                                             │
│   └─────────┘                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 刷题流程详细图
```
┌────────────────────────────────────────────────────────────────┐
│                          刷题主流程                            │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  [进入题库] ──→ [显示第N题] ──→ [用户选择答案]                 │
│                      ↑               │                         │
│                      │               ↓                         │
│                      │         ┌───────────┐                   │
│                      │         │ 单选题？   │                   │
│                      │         └─────┬─────┘                   │
│                      │               │                         │
│                      │    ┌────Yes───┴───No────┐               │
│                      │    ↓                    ↓               │
│                      │ [自动提交]        [点击确认]             │
│                      │    │                    │               │
│                      │    └────────┬───────────┘               │
│                      │             ↓                           │
│                      │    ┌───────────────┐                    │
│                      │    │  判断对错      │                    │
│                      │    └───────┬───────┘                    │
│                      │            │                            │
│                      │    ┌───────┴───────┐                    │
│                      │    ↓               ↓                    │
│                      │ [显示正确]     [显示错误]                │
│                      │ [绿色反馈]     [红色反馈]                │
│                      │    │           [加入错题本]              │
│                      │    │               │                    │
│                      │    └───────┬───────┘                    │
│                      │            ↓                            │
│                      │    [显示解析]                           │
│                      │            │                            │
│                      │            ↓                            │
│                      │    ┌───────────────┐                    │
│                      │    │ 还有下一题？   │                    │
│                      │    └───────┬───────┘                    │
│                      │            │                            │
│                      │    ┌───Yes─┴───No───┐                   │
│                      │    │                │                   │
│                      │    ↓                ↓                   │
│                      └─[下一题]      [完成提示]                 │
│                                           │                    │
│                                    ┌──────┴──────┐             │
│                                    ↓             ↓             │
│                              [从头再刷]    [返回题库]           │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 5.3 题库管理流程图
```
┌────────────────────────────────────────────────────────────────┐
│                        题库管理流程                            │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  [题库列表页]                                                  │
│       │                                                        │
│       ├──→ [点击已下载题库] ──→ [进入刷题页面]                 │
│       │                                                        │
│       ├──→ [点击下载按钮] ──→ [检查存储空间]                   │
│       │                            │                           │
│       │                     ┌──────┴──────┐                    │
│       │                     ↓             ↓                    │
│       │               [空间充足]     [空间不足]                 │
│       │                     │             │                    │
│       │                     ↓             ↓                    │
│       │              [显示下载进度]  [弹窗提示]                 │
│       │                     │                                  │
│       │              ┌──────┴──────┐                           │
│       │              ↓             ↓                           │
│       │         [下载成功]    [下载失败]                       │
│       │              │             │                           │
│       │              ↓             ↓                           │
│       │         [移至已下载]  [显示重试按钮]                   │
│       │                                                        │
│       ├──→ [长按已下载题库] ──→ [弹出菜单]                     │
│       │                            │                           │
│       │                     ┌──────┴──────┐                    │
│       │                     ↓             ↓                    │
│       │               [重置进度]     [删除题库]                 │
│       │                     │             │                    │
│       │                     ↓             ↓                    │
│       │               [确认弹窗]     [确认弹窗]                 │
│       │                     │             │                    │
│       │                     ↓             ↓                    │
│       │              [清空答题记录] [删除题库文件]              │
│       │              [保留错题收藏]                             │
│       │                                                        │
│       └──→ [发现更新标识] ──→ [点击更新] ──→ [确认弹窗]        │
│                                                 │              │
│                                                 ↓              │
│                                          [下载新版本]          │
│                                          [保留用户数据]        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 6. 功能优先级

### P0（核心功能，必须实现）
- 题库管理（下载、删除、列表、内置默认题库）
- 顺序刷题模式
- 答题界面（单选/多选/判断题）
- 答题反馈和解析
- 错题本
- 本地数据存储
- 进度记录
- 深色模式支持

### P1（重要功能，优先实现）
- 随机模式
- 收藏功能
- 错题模式刷题
- 收藏模式刷题
- 统计页面
- 上一题/跳过功能
- 左右滑动手势
- 数据重置
- 题库更新机制

### P2（增强功能，可后期实现）
- 多语言切换（中/英）
- 下载进度优化（断点续传）
- 数据导出功能

---

## 7. 非功能需求

### 7.1 性能要求
- 应用启动时间：< 2秒
- 题目切换动画流畅：60fps
- 题库下载速度：根据网络速度，显示进度
- 大题库（5000题）加载时间：< 1秒

### 7.2 兼容性要求
- iOS 13+ 全系列机型
- Android 8.0+ 主流机型
- 屏幕适配：4.7寸 - 6.7寸

### 7.3 稳定性要求
- 应用崩溃率：< 0.1%
- 数据丢失率：0%（本地数据持久化）
- 离线使用稳定性：100%

### 7.4 可用性要求
- 完全离线使用（下载题库后）
- 无需注册登录
- 数据本地存储，永久保留

---

## 8. 约束条件

### 8.1 技术约束
- 题库数据从云端下载
- 答题记录仅存储在本地
- 不涉及用户账号体系
- 不涉及数据同步

### 8.2 业务约束
- 暂不支持付费题库
- 暂不支持广告
- 暂不支持社交功能
- 暂不支持模拟考试模式

### 8.3 资源约束
- 每个题库：≤ 5000题
- 单个题库大小：≤ 10MB
- 应用安装包大小：≤ 50MB

---

## 9. 后续迭代方向

### V1.0（MVP）
- 核心刷题功能（单选/多选/判断）
- 错题本
- 收藏功能
- 基础统计
- 深色模式
- 内置默认题库

### V1.1
- 多语言支持（中/英）
- 更多统计维度
- 性能优化

### V2.0（未来）
- 模拟考试模式
- 章节练习
- 数据云同步（需账号体系）
- 付费题库
- 社交功能（分享、排行榜）

---

## 10. 成功指标

### 10.1 产品指标
- 日活用户数（DAU）
- 题库下载量
- 人均刷题数
- 错题本使用率
- 用户留存率（次日/7日/30日）

### 10.2 体验指标
- 用户满意度（App Store评分）
- 应用崩溃率
- 页面加载速度
- 功能使用率

---

## 11. 风险与应对

### 11.1 技术风险
**风险**：题库数据量大，下载时间长
**应对**：
- 压缩题库数据
- 支持断点续传
- 提供下载进度反馈

**风险**：本地数据存储占用空间大
**应对**：
- 优化数据结构
- 提供清理功能
- 题库可删除

### 11.2 产品风险
**风险**：用户刷题动力不足
**应对**：
- 清晰的进度展示
- 错题本帮助巩固
- 未来考虑增加激励机制

---

## 12. 测试用例概要

### 12.1 题库管理测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 查看题库列表 | 1. 打开App | 显示内置题库和可下载题库列表 |
| 下载题库 | 1. 点击下载按钮 2. 等待下载完成 | 显示下载进度，完成后移至已下载区域 |
| 下载失败重试 | 1. 模拟网络断开 2. 点击下载 3. 点击重试 | 显示错误提示，重试后继续下载 |
| 存储不足 | 1. 模拟存储空间不足 2. 点击下载 | 弹窗提示存储空间不足 |
| 删除题库 | 1. 长按已下载题库 2. 点击删除 3. 确认 | 题库被删除，答题记录保留（若重新下载） |
| 重置进度 | 1. 长按题库 2. 点击重置进度 3. 确认 | 刷题进度清空，错题和收藏保留 |
| 题库更新 | 1. 服务端更新题库版本 2. 进入题库列表 | 显示"有更新"标识 |
| 更新题库 | 1. 点击有更新的题库 2. 确认更新 | 下载新版本，保留用户数据 |

### 12.2 刷题功能测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 顺序刷题 | 1. 进入题库 2. 答题 3. 下一题 | 按顺序显示题目，记录进度 |
| 继续刷题 | 1. 刷到第50题 2. 退出 3. 重新进入 | 从第50题继续 |
| 单选题答题 | 1. 选择一个选项 | 自动提交，显示对错和解析 |
| 多选题答题 | 1. 选择多个选项 2. 点击确认 | 提交后显示对错和解析 |
| 判断题答题 | 1. 选择正确/错误 | 自动提交，显示对错和解析 |
| 答对反馈 | 1. 选择正确答案 | 绿色提示，显示解析 |
| 答错反馈 | 1. 选择错误答案 | 红色提示，显示正确答案，加入错题本 |
| 跳过题目 | 1. 点击跳过 | 进入下一题，当前题标记为未作答 |
| 上一题 | 1. 答完一题 2. 点击上一题 | 返回上一题，显示之前的答案 |
| 左滑下一题 | 1. 向左滑动 | 进入下一题 |
| 右滑上一题 | 1. 向右滑动 | 返回上一题 |
| 刷完全部题 | 1. 刷到最后一题 2. 点击下一题 | 弹窗提示完成，可选从头再刷 |
| 从头再刷 | 1. 刷完后选择从头再刷 | 进度清空，错题收藏保留，从第1题开始 |

### 12.3 随机模式测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 切换随机模式 | 1. 点击模式按钮 2. 选择随机 | 切换到随机模式 |
| 随机不重复 | 1. 随机模式刷题 | 不会刷到已刷过的题 |
| 随机刷完 | 1. 随机刷完所有题 | 提示已完成，可重置 |

### 12.4 错题本测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 错题记录 | 1. 答错一道题 | 自动加入错题本 |
| 查看错题 | 1. 切换到错题模式 | 显示所有错题 |
| 错题为空 | 1. 无错题时进入错题模式 | 显示空状态页面 |
| 标记已掌握 | 1. 错题模式 2. 点击已掌握 | 题目从错题本移除 |
| 重新答错 | 1. 已掌握的题再次答错 | 重新加入错题本 |

### 12.5 收藏功能测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 收藏题目 | 1. 点击星标 | 星标变黄，加入收藏 |
| 取消收藏 | 1. 点击已收藏的星标 | 星标变白，移出收藏 |
| 查看收藏 | 1. 切换到收藏模式 | 显示所有收藏题目 |
| 收藏为空 | 1. 无收藏时进入收藏模式 | 显示空状态页面 |

### 12.6 统计功能测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 查看统计 | 1. 点击统计按钮 | 显示统计数据 |
| 统计准确性 | 1. 刷10题，答对7题 | 正确率显示70% |

### 12.7 设置功能测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 切换深色模式 | 1. 打开设置 2. 切换深色模式 | 界面切换为深色主题 |
| 切换语言 | 1. 打开设置 2. 切换语言为英文 | 界面文字切换为英文 |
| 清除所有数据 | 1. 打开设置 2. 清除数据 3. 确认 | 所有答题记录、错题、收藏被清除 |

### 12.8 离线功能测试

| 测试场景 | 测试步骤 | 预期结果 |
|---------|---------|---------|
| 离线刷题 | 1. 下载题库 2. 断开网络 3. 刷题 | 正常刷题，数据正常保存 |
| 离线数据保存 | 1. 离线答题 2. 退出App 3. 重新打开 | 数据正常保留 |

---

## 13. 隐私政策

### 13.1 数据收集声明
**驾考刷刷**应用承诺完全不收集任何用户个人数据。

### 13.2 数据存储
- 所有用户数据（答题记录、错题、收藏、设置偏好）仅存储在用户设备本地
- 不上传至任何服务器
- 不进行任何形式的数据同步

### 13.3 网络请求
应用仅在以下场景使用网络：
- 获取可下载题库列表
- 下载题库数据
- 检测题库更新

### 13.4 第三方服务
- 本应用不集成任何第三方统计SDK
- 不集成任何广告SDK
- 不分享任何数据给第三方

### 13.5 数据删除
- 用户可通过设置页面的"清除所有数据"功能删除本地所有数据
- 卸载应用将自动删除所有本地数据

---

## 14. 附录

### 14.1 术语表
- **题库**：一套完整的驾考题目集合
- **刷题**：按顺序或随机练习题目
- **错题本**：记录做错题目的集合
- **收藏**：用户标记的重点题目
- **已掌握**：用户标记已经掌握的错题

### 14.2 参考资料
- 百词斩APP交互设计
- 驾考宝典APP功能参考
- 各地驾考题库标准

---

**文档版本**：V1.3  
**创建日期**：2026-01-23  
**最后更新**：2026-01-23  
**文档状态**：待评审

---

## 变更记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| V1.0 | 2026-01-23 | - | 初始版本 |
| V1.1 | 2026-01-23 | - | 补充详细技术栈：Flutter + Golang |
| V1.2 | 2026-01-23 | - | 完善产品细节：产品命名、题库更新机制、判断题、手势交互、测试用例、隐私政策 |
| V1.3 | 2026-01-23 | - | **UI/UX设计大幅优化**：设计理念与风格、完整色彩系统（品牌色/语义色/渐变色）、排版系统（字号层级/字重）、间距与网格系统、圆角与阴影层级、动效设计规范（5种核心动效详解）、触觉反馈规范、组件设计规范（8类核心组件）、图标与插图风格、情感化设计（激励/里程碑/微文案）、无障碍设计、4个核心页面详细布局设计 |
