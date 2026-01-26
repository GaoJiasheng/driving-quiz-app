# 驾考刷刷 (DriveQuiz)

一款专注于驾校题目练习的移动应用，提供卡片式刷题体验。

## 📱 项目简介

**驾考刷刷**是一款支持多题库、离线使用、智能错题管理的驾考学习应用。

- **平台**: iOS / Android / macOS
- **技术栈**: Flutter 3.19+ + Golang 1.21+
- **版本**: V1.0

## ✨ 核心功能

- 📚 多题库管理（下载、更新、删除）
- 📝 四种刷题模式（顺序、随机、错题、收藏）
- ❌ 智能错题本
- ⭐ 题目收藏与标记
- 📊 学习统计与进度跟踪
- 🌙 深色模式
- 📴 完全离线使用

## 🚀 快速开始

### 1. 启动后端服务

```bash
cd backend
go run main.go
```

后端服务将在 `http://localhost:8080` 启动。

### 2. 运行移动应用

```bash
cd mobile
flutter pub get
flutter run
```

> **注意**: macOS平台需要安装Xcode。建议使用iOS模拟器或Android模拟器进行测试。

详细开发指南请查看 [`docs/DEVELOPMENT.md`](./docs/DEVELOPMENT.md)

## 📊 开发进度

### ✅ 已完成

- [x] **后端服务** (100%)
  - [x] 3个API接口（健康检查、题库列表、题库下载）
  - [x] Mock数据（Demo 50题 + 科目一 1500题 + 科目四 1200题）
  - [x] 单元测试（21个测试，85%+覆盖率）
  - [x] CORS支持、错误处理、日志系统

- [x] **前端数据层** (100%)
  - [x] SQLite数据库（Drift ORM）
  - [x] 网络层（Dio）
  - [x] Repository模式
  - [x] 数据模型与序列化

- [x] **前端状态管理** (100%)
  - [x] Riverpod Provider架构
  - [x] 题库管理Provider
  - [x] 刷题逻辑Provider
  - [x] 统计数据Provider
  - [x] 下载进度管理

- [x] **前端UI - P0核心功能** (100%)
  - [x] 题库列表页（我的题库 + 题库商店）
  - [x] 刷题页（题目展示、答题、导航、答题卡）

- [x] **前端UI - P1重要功能** (100%)
  - [x] 统计页（总体统计 + 题库详情）
  - [x] 设置页（主题、数据管理、关于）
  - [x] 底部导航（题库、统计、设置）

### 🎯 总体进度: ~97%

### ✅ 最新完成

- [x] **P2 次要功能** (已完成 70%)
  - [x] 深色模式 ⭐
  - [x] 搜索功能 ⭐
  - [x] 应用图标和启动页 ⭐

- [x] **性能优化** (已完成 100%) ⭐
  - [x] 数据库索引优化
  - [x] Provider AutoDispose
  - [x] 网络连接池
  - [x] 缓存策略优化

### 📋 待完成

- [ ] 题库数据扩展
  - [ ] 更多地区题库
  - [ ] 题目图片支持

- [ ] 测试
  - [ ] 单元测试
  - [ ] 集成测试

- [ ] 发布准备
  - [ ] 应用商店资料

## 📁 项目结构

```
driving-quiz-app/
├── backend/              # Golang 后端服务
│   ├── api/             # API处理器
│   ├── service/         # 业务逻辑
│   ├── model/           # 数据模型
│   ├── data/            # Mock数据
│   └── main.go          # 入口文件
│
├── mobile/              # Flutter 移动应用
│   ├── lib/
│   │   ├── core/        # 核心功能（数据库、网络）
│   │   ├── models/      # 数据模型
│   │   ├── repositories/# 数据仓库
│   │   ├── providers/   # 状态管理
│   │   ├── features/    # 功能页面
│   │   ├── widgets/     # 通用组件
│   │   └── config/      # 配置文件
│   └── pubspec.yaml     # 依赖配置
│
└── docs/                # 项目文档
    ├── PRD.md           # 产品需求文档
    ├── API.md           # API接口文档
    ├── ARCHITECTURE.md  # 架构设计文档
    ├── DEVELOPMENT.md   # 开发指南
    ├── TESTING.md       # 测试指南
    └── CHANGELOG.md     # 开发日志
```

## 📚 文档

- [产品需求文档 (PRD)](./docs/PRD.md) - 产品功能和需求
- [架构设计文档](./docs/ARCHITECTURE.md) - 技术架构和设计决策
- [开发指南](./docs/DEVELOPMENT.md) - 开发环境配置和快速开始
- [API 文档](./docs/API.md) - 后端API接口说明
- [测试指南](./docs/TESTING.md) - 测试方法和流程
- [开发日志](./docs/CHANGELOG.md) - 开发历程和里程碑

## 🛠️ 技术栈

### 后端
- **语言**: Golang 1.21+
- **框架**: Gin 1.9+
- **工具**: CORS, 自定义日志

### 前端
- **框架**: Flutter 3.19+
- **语言**: Dart 3.3+
- **状态管理**: Riverpod 2.6+
- **数据库**: Drift (SQLite)
- **网络**: Dio 5.7+
- **工具**: build_runner, json_annotation

## 🧪 测试

### 后端测试

```bash
cd backend
go test ./... -v
go test ./... -cover
```

- ✅ 21个单元测试
- ✅ 85%+代码覆盖率
- ✅ 5个性能基准测试

### 前端测试

详细测试流程请查看 [`docs/TESTING.md`](./docs/TESTING.md)

## 📄 License

MIT License

## 📮 联系方式

如有问题或建议，欢迎提交 Issue。

---

**最后更新**: 2026-01-23
