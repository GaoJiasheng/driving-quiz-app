# DriveQuiz Mobile

驾考刷刷移动端 - 基于 Flutter 开发

## 技术栈

- **框架**: Flutter 3.19+
- **语言**: Dart 3.3+
- **状态管理**: Riverpod
- **本地存储**: Drift (SQLite)
- **网络请求**: Dio

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── app.dart                     # App根组件
├── config/                      # 配置文件
│   ├── app_config.dart          # 应用配置
│   └── theme.dart               # 主题配置
├── core/                        # 核心层
│   ├── database/                # 数据库
│   │   ├── database.dart        # Drift数据库定义
│   │   └── tables/              # 数据表定义
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
│   └── repositories/            # 数据仓库
├── providers/                   # Riverpod状态管理
├── features/                    # 功能模块
│   ├── bank_list/               # 题库列表
│   ├── quiz/                    # 刷题模块
│   ├── statistics/              # 统计模块
│   └── settings/                # 设置模块
├── l10n/                        # 国际化
│   ├── app_zh.arb               # 中文
│   └── app_en.arb               # 英文
└── widgets/                     # 通用组件
```

## 快速开始

### 安装依赖

```bash
flutter pub get
```

### 代码生成

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行应用

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# 指定设备
flutter run -d <device_id>
```

### 查看可用设备

```bash
flutter devices
```

## 开发流程

### 1. 数据模型开发

1. 在 `lib/data/models/` 创建模型类
2. 添加 JSON 序列化注解
3. 运行代码生成：`flutter pub run build_runner build`

### 2. 数据库开发

1. 在 `lib/core/database/tables/` 定义表结构
2. 在 `database.dart` 注册表
3. 运行代码生成
4. 在 Repository 中实现数据访问

### 3. 状态管理

1. 在 `lib/providers/` 创建 Provider
2. 使用 Riverpod 注解（推荐）
3. 在 UI 中通过 `ref.watch()` 监听状态

### 4. UI 开发

1. 在 `lib/features/` 创建功能模块
2. 遵循 PRD 中的设计规范
3. 使用通用组件库（`lib/widgets/`）

## 代码规范

### 命名规范

- 文件名：`snake_case.dart`
- 类名：`PascalCase`
- 变量/函数：`camelCase`
- 常量：`camelCase` 或 `SCREAMING_SNAKE_CASE`

### 目录组织

- 按功能模块组织代码
- 每个模块包含 UI、逻辑、组件
- 共享组件放在 `widgets/`

### 导入顺序

1. Dart SDK
2. Flutter SDK
3. 第三方包
4. 项目内部包

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

import 'package:driving_quiz_app/config/theme.dart';
```

## 测试

### 单元测试

```bash
flutter test
```

### Widget 测试

```bash
flutter test test/widgets/
```

### 集成测试

```bash
flutter test integration_test/
```

## 打包

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (推荐)
flutter build appbundle --release
```

### iOS

```bash
# Release IPA
flutter build ipa --release
```

## 依赖说明

### 核心依赖

- `flutter_riverpod`: 状态管理
- `drift`: SQLite ORM
- `dio`: HTTP 客户端
- `flutter_screenutil`: 屏幕适配

### UI 依赖

- `cached_network_image`: 图片缓存
- `flutter_svg`: SVG 支持
- `shimmer`: 骨架屏

### 工具依赖

- `intl`: 国际化
- `shared_preferences`: 轻量存储
- `path_provider`: 文件路径

## 常见问题

### 1. 代码生成失败

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. 依赖冲突

```bash
flutter pub upgrade --major-versions
```

### 3. iOS 构建失败

```bash
cd ios
pod install
cd ..
flutter clean
flutter run
```

## 开发进度

- [x] 项目初始化
- [x] 主题系统配置
- [ ] 数据库设计
- [ ] 网络层封装
- [ ] 题库列表页面
- [ ] 答题界面
- [ ] 错题本功能
- [ ] 统计功能
- [ ] 设置页面

## 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request
