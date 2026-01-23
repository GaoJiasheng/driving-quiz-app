# 开发指南

本文档提供完整的开发环境配置、快速开始和开发流程说明。

## 📋 环境要求

### 后端开发

- **Golang**: 1.21 或更高版本
- **包管理**: Go Modules
- **推荐IDE**: VSCode / GoLand

### 前端开发

- **Flutter**: 3.19.0 或更高版本
- **Dart**: 3.3.0 或更高版本
- **平台支持**: 
  - iOS 13.0+
  - Android 8.0+ (API 26+)
  - macOS 10.14+ (需要Xcode)
- **推荐IDE**: VSCode / Android Studio

### 开发工具

```bash
# 检查Flutter环境
flutter doctor

# 检查Go版本
go version

# 推荐安装的工具
flutter pub global activate build_runner
```

## 🚀 快速开始

### 方式一：命令行快速启动（推荐）

#### 1️⃣ 启动后端（终端1）

```bash
cd backend
go run main.go
```

**看到以下输出说明成功**：
```
🚀 Starting DriveQuiz Backend Server...
✅ Server is ready at http://localhost:8080
📚 Available endpoints:
   - GET  /api/health
   - GET  /api/banks
   - GET  /api/banks/:id/download
```

#### 2️⃣ 运行前端（终端2）

```bash
cd mobile

# 首次运行需要安装依赖
flutter pub get

# 运行应用 (自动选择可用设备)
flutter run
```

#### 3️⃣ 选择运行设备

**推荐选项**：
- **iOS模拟器**: 最快捷，运行 `open -a Simulator`
- **Android模拟器**: 通过Android Studio启动AVD
- **macOS**: 需要完整Xcode支持

> **注意**: Web平台不支持SQLite，无法运行本应用。

### 方式二：分步详细配置

#### 后端设置

```bash
# 1. 进入后端目录
cd /Users/gavin/driving-quiz-app/backend

# 2. 安装依赖
go mod download
go mod tidy

# 3. 验证依赖
go mod verify

# 4. 运行服务
go run main.go
```

**测试后端API**:
```bash
# 健康检查
curl http://localhost:8080/api/health

# 获取题库列表
curl http://localhost:8080/api/banks

# 下载题库（保存到文件）
curl http://localhost:8080/api/banks/demo_bank/download -o demo_bank.json
```

#### 前端设置

```bash
# 1. 进入前端目录
cd /Users/gavin/driving-quiz-app/mobile

# 2. 检查Flutter环境
flutter doctor

# 3. 安装依赖
flutter pub get

# 4. 生成代码（数据库、JSON序列化）
flutter pub run build_runner build --delete-conflicting-outputs

# 5. 列出可用设备
flutter devices

# 6. 运行应用（指定设备）
flutter run -d <device_id>

# 或者直接运行（自动选择）
flutter run
```

## 📱 设备选择指南

### iOS模拟器（最简单）

```bash
# 启动模拟器
open -a Simulator

# 等待模拟器启动后
cd mobile
flutter run
```

### Android模拟器

```bash
# 1. 打开Android Studio
# 2. Tools -> AVD Manager
# 3. 启动一个模拟器

# 或使用命令行
emulator -avd <avd_name>

# 运行应用
cd mobile
flutter run
```

### macOS桌面应用

```bash
# 需要安装完整Xcode
xcode-select --install

# 或从App Store下载Xcode

# 运行
cd mobile
flutter run -d macos
```

### 物理设备

#### iOS设备
1. 连接iPhone/iPad到Mac
2. 信任开发者证书
3. 在Xcode中配置Team和Bundle ID
4. `flutter run`

#### Android设备
1. 开启开发者选项和USB调试
2. 连接设备到电脑
3. 授权USB调试
4. `flutter run`

## 🛠️ 开发工作流

### 1. 启动开发环境

```bash
# 启动后端（保持运行）
cd backend && go run main.go

# 新终端：启动前端（热重载模式）
cd mobile && flutter run
```

### 2. 热重载开发

Flutter支持热重载，修改代码后：
- 按 `r` - 热重载
- 按 `R` - 热重启（完整重启）
- 按 `q` - 退出

### 3. 代码生成

当修改数据模型或数据库时，需要重新生成代码：

```bash
cd mobile

# 一次性生成
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式（自动生成）
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. 清理缓存

遇到奇怪问题时：

```bash
# Flutter清理
cd mobile
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Go清理
cd backend
go clean
go mod tidy
```

## 📂 项目结构说明

### 后端结构

```
backend/
├── main.go              # 入口文件，路由配置
├── go.mod/go.sum        # 依赖管理
│
├── api/                 # API层
│   ├── handler.go       # HTTP请求处理器
│   └── handler_test.go  # API测试
│
├── service/             # 业务逻辑层
│   ├── bank_service.go       # 题库服务
│   └── bank_service_test.go  # 服务测试
│
├── model/               # 数据模型
│   └── bank.go          # 题库、题目模型
│
├── config/              # 配置管理
│   └── config.go
│
├── utils/               # 工具类
│   └── logger.go        # 日志工具
│
└── data/                # Mock数据
    ├── banks.json       # 题库元数据
    └── banks/           # 题库内容
        ├── demo_bank.json        # 示例题库 (50题)
        └── cn_subject1_v1.json   # 科目一 (1500题)
```

### 前端结构

```
mobile/
├── pubspec.yaml         # 依赖配置
├── lib/
│   ├── main.dart        # 应用入口
│   ├── app.dart         # App Widget
│   │
│   ├── core/            # 核心功能
│   │   ├── database/    # 数据库 (Drift)
│   │   ├── network/     # 网络请求 (Dio)
│   │   └── constants/   # 常量定义
│   │
│   ├── models/          # 数据模型
│   │   ├── bank_model.dart
│   │   ├── question_model.dart
│   │   └── stats_model.dart
│   │
│   ├── repositories/    # 数据仓库
│   │   ├── bank_repository.dart
│   │   ├── answer_repository.dart
│   │   └── stats_repository.dart
│   │
│   ├── providers/       # 状态管理 (Riverpod)
│   │   ├── database_provider.dart
│   │   ├── bank_provider.dart
│   │   ├── quiz_provider.dart
│   │   └── stats_provider.dart
│   │
│   ├── features/        # 功能页面
│   │   ├── bank_list/   # 题库管理
│   │   ├── quiz/        # 刷题页面
│   │   ├── statistics/  # 统计页面
│   │   ├── settings/    # 设置页面
│   │   └── home/        # 主导航
│   │
│   ├── widgets/         # 通用组件
│   │   └── ...
│   │
│   └── config/          # 配置文件
│       ├── theme.dart   # 主题配置
│       └── routes.dart  # 路由配置
│
└── test/                # 测试文件
```

## 🔧 常用开发命令

### 后端命令

```bash
# 运行服务
go run main.go

# 运行测试
go test ./... -v

# 测试覆盖率
go test ./... -cover
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out

# 性能测试
go test ./... -bench=. -benchmem

# 构建二进制
go build -o driveqiz-server main.go

# 格式化代码
go fmt ./...

# 代码检查
go vet ./...
```

### 前端命令

```bash
# 运行应用
flutter run
flutter run -d <device_id>
flutter run --release          # 发布模式

# 测试
flutter test                   # 单元测试
flutter test --coverage        # 测试覆盖率

# 代码生成
flutter pub run build_runner build
flutter pub run build_runner watch

# 分析代码
flutter analyze

# 格式化代码
dart format lib/

# 检查过时依赖
flutter pub outdated

# 升级依赖
flutter pub upgrade

# 清理
flutter clean

# 构建
flutter build apk              # Android APK
flutter build ios              # iOS
flutter build macos            # macOS
```

## 📝 开发规范

### 代码风格

**Golang**:
- 遵循 [Effective Go](https://go.dev/doc/effective_go)
- 使用 `gofmt` 格式化
- 变量命名使用驼峰命名法

**Dart/Flutter**:
- 遵循 [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- 使用 `dart format` 格式化
- 类名使用大驼峰，变量名使用小驼峰
- 文件名使用小写下划线

### Git提交规范

```bash
# 格式
<type>(<scope>): <subject>

# 类型
feat:     新功能
fix:      修复bug
docs:     文档更新
style:    代码格式调整
refactor: 重构
test:     测试相关
chore:    构建/工具配置

# 示例
feat(backend): 添加题库搜索接口
fix(quiz): 修复答题记录保存失败
docs: 更新开发指南
```

### 分支管理

```bash
main          # 主分支，稳定版本
develop       # 开发分支
feature/xxx   # 功能分支
bugfix/xxx    # 修复分支
release/xxx   # 发布分支
```

## 🐛 调试技巧

### 后端调试

```bash
# 详细日志
VERBOSE=true go run main.go

# 使用调试器（VSCode）
# 在launch.json中配置Go调试
```

### 前端调试

```bash
# 运行调试模式
flutter run --debug

# 启用Dart DevTools
flutter pub global activate devtools
flutter pub global run devtools

# 查看Provider状态
# 使用Riverpod DevTools扩展

# 查看数据库
# 使用DB Browser for SQLite
# 数据库位置: 
# - Android: /data/data/com.example.driving_quiz_app/databases/
# - iOS: Library/Application Support/
```

## ⚠️ 常见问题

### 1. Flutter环境问题

**问题**: `flutter doctor` 显示错误

**解决**:
```bash
flutter doctor -v          # 查看详细信息
flutter upgrade            # 升级Flutter
flutter config --no-analytics  # 禁用分析
```

### 2. 依赖冲突

**问题**: `flutter pub get` 失败

**解决**:
```bash
# 清理并重新安装
flutter clean
rm pubspec.lock
flutter pub get

# 查看过时依赖
flutter pub outdated
```

### 3. 代码生成失败

**问题**: `build_runner` 报错

**解决**:
```bash
# 清理旧生成文件
flutter packages pub run build_runner clean

# 强制重新生成
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Xcode相关问题

**问题**: macOS运行失败，提示需要xcodebuild

**解决**:
```bash
# 安装Xcode命令行工具
xcode-select --install

# 或从App Store安装完整Xcode
# 安装后设置路径
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

### 5. Android模拟器慢

**解决**:
- 确保启用了硬件加速 (Intel HAXM / AMD Hypervisor)
- 使用x86_64镜像而非ARM
- 分配足够的RAM和CPU核心

### 6. 后端API无法访问

**问题**: 前端无法连接后端

**检查**:
```bash
# 1. 后端是否运行
curl http://localhost:8080/api/health

# 2. 检查防火墙
# 3. iOS模拟器使用 localhost
# 4. Android模拟器使用 10.0.2.2
# 5. 物理设备使用电脑IP地址
```

## 📦 依赖说明

### 后端依赖

```go
require (
    github.com/gin-gonic/gin v1.9.1      // Web框架
    github.com/gin-contrib/cors v1.7.2   // CORS支持
)
```

### 前端核心依赖

```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # 状态管理
  riverpod_annotation: ^2.6.1   
  
  drift: ^2.22.0                 # SQLite ORM
  sqlite3_flutter_libs: ^0.5.24 # SQLite库
  path_provider: ^2.1.5          # 路径工具
  
  dio: ^5.7.0                    # HTTP客户端
  
  json_annotation: ^4.8.1        # JSON序列化
  equatable: ^2.0.5              # 值相等性
  flutter_screenutil: ^5.9.3     # 屏幕适配
  package_info_plus: ^8.0.0      # 应用信息

dev_dependencies:
  build_runner: ^2.4.13          # 代码生成
  drift_dev: ^2.22.0             # Drift代码生成
  json_serializable: ^6.6.2      # JSON代码生成
  riverpod_generator: ^2.6.2     # Riverpod代码生成
```

## 🎓 学习资源

### Flutter学习
- [Flutter官方文档](https://docs.flutter.dev/)
- [Dart语言教程](https://dart.dev/guides)
- [Riverpod文档](https://riverpod.dev/)
- [Drift文档](https://drift.simonbinder.eu/)

### Golang学习
- [Go官方文档](https://go.dev/doc/)
- [Gin框架文档](https://gin-gonic.com/docs/)
- [Effective Go](https://go.dev/doc/effective_go)

## 💡 开发提示

1. **善用热重载**: Flutter的热重载可以大大提升开发效率
2. **Provider调试**: 使用Riverpod DevTools查看状态变化
3. **数据库查看**: 使用DB Browser for SQLite查看本地数据
4. **API测试**: 使用Postman或curl测试后端接口
5. **代码格式化**: 配置IDE自动格式化
6. **Git提交**: 小步提交，清晰的commit message

---

**最后更新**: 2026-01-23

如有问题，请查看 [测试指南](./TESTING.md) 或提交Issue。
