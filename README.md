# 驾考刷刷 (DriveQuiz)

一款专注于驾校题目练习的移动应用，提供卡片式刷题体验。

## 项目简介

**驾考刷刷**是一款支持多题库、离线使用、智能错题管理的驾考学习应用。

- **平台**: iOS / Android
- **技术栈**: Flutter + Golang
- **版本**: V1.0

## 核心功能

- 📚 多题库管理（下载、更新、删除）
- 📝 四种刷题模式（顺序、随机、错题、收藏）
- ❌ 智能错题本
- ⭐ 题目收藏
- 📊 学习统计
- 🌙 深色模式
- 📴 完全离线使用

## 项目结构

```
driving-quiz-app/
├── backend/          # Golang 后端服务
├── mobile/           # Flutter 移动应用
├── docs/            # 项目文档
├── design/          # 设计资源
└── README.md
```

## 开发环境要求

### 后端
- Golang 1.21+
- Gin 1.9+

### 前端
- Flutter 3.19+
- Dart 3.3+
- iOS 13+ / Android 8.0+

## 快速开始

### 启动后端服务

```bash
cd backend

# 安装依赖
go mod download
go mod tidy

# 运行服务
go run main.go
```

后端服务将在 `http://localhost:8080` 启动。

✅ **后端已完成！**包含3个API接口和60题真实数据。

详细说明请查看：
- `backend/README.md` - 后端文档
- `backend/BACKEND_COMPLETE.md` - 完成情况总结

### 运行移动应用

```bash
cd mobile
flutter pub get
flutter run
```

## 开发进度

- [x] 项目初始化
- [x] **后端 API 开发** ✅
  - [x] 健康检查接口
  - [x] 题库列表接口
  - [x] 题库下载接口
  - [x] Mock数据（Demo 50题 + 科目一 10题）
- [ ] 前端核心功能
- [ ] 题库数据准备（扩展更多题目）
- [ ] 测试与优化
- [ ] 发布准备

## 文档

- [产品需求文档 (PRD)](./docs/PRD.md)
- [数据结构文档](./docs/data-schema.md)
- [API 文档](./docs/API.md)
- [用户指南](./docs/USER_GUIDE.md)

## License

MIT License

## 联系方式

如有问题或建议，欢迎提交 Issue。
