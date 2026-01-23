# 驾考刷刷 - 后端服务

基于 Golang + Gin 的 RESTful API 服务。

## ✅ 当前状态

- ✅ 基础框架已完成
- ✅ API 路由已实现
- ✅ Mock 数据已创建
- ✅ 可以正常运行和测试

## 技术栈

- **语言**: Golang 1.21+
- **框架**: Gin 1.9+
- **日志**: zap
- **CORS**: gin-contrib/cors

## 项目结构

```
backend/
├── main.go              # 应用入口 ✅
├── go.mod               # Go模块配置 ✅
├── .env.example         # 环境变量示例 ✅
│
├── config/              # 配置层
│   └── config.go        ✅
│
├── api/                 # API处理层
│   └── handler.go       # 路由处理器 ✅
│
├── service/             # 业务逻辑层
│   └── bank_service.go  # 题库服务 ✅
│
├── model/               # 数据模型
│   └── bank.go          ✅
│
├── utils/               # 工具类
│   └── logger.go        ✅
│
└── data/                # 数据目录
    ├── banks.json       # 题库元数据 ✅
    └── banks/           # 题库文件
        ├── demo_bank.json          ✅ (50题)
        └── cn_subject1_v1.json     ✅ (10题示例)
```

## 快速开始

### 1. 安装依赖

```bash
cd backend
go mod download
go mod tidy
```

### 2. 运行服务

```bash
go run main.go
```

服务将在 `http://localhost:8080` 启动。

你会看到如下输出：
```
🚀 Starting DriveQuiz Backend Server...
✅ BankService initialized
✅ Server is ready at http://localhost:8080
📚 Available endpoints:
   - GET  /api/health
   - GET  /api/banks
   - GET  /api/banks/:id/download
```

### 3. 测试 API

```bash
# 健康检查
curl http://localhost:8080/api/health

# 获取题库列表
curl http://localhost:8080/api/banks

# 下载Demo题库
curl http://localhost:8080/api/banks/demo_bank/download -o demo_bank.json

# 下载科目一题库
curl http://localhost:8080/api/banks/cn_subject1_v1/download -o cn_subject1.json
```

## API 端点

### 1. 健康检查

```http
GET /api/health
```

**响应示例**:

```json
{
  "status": "ok",
  "message": "DriveQuiz Backend API is running",
  "version": "1.0.0"
}
```

### 2. 获取题库列表

```http
GET /api/banks
```

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "question_banks": [
      {
        "id": "demo_bank",
        "name": "示例题库",
        "description": "内置示例题库，包含各类题型演示",
        "total_questions": 50,
        "version": "1.0.0",
        "language": "zh-CN",
        "size": 102400,
        "updated_at": "2026-01-23T10:00:00Z"
      },
      {
        "id": "cn_subject1_v1",
        "name": "中国驾照科目一",
        "description": "科目一理论考试题库",
        "total_questions": 1500,
        "version": "1.0.0",
        "language": "zh-CN",
        "size": 5242880,
        "updated_at": "2026-01-23T10:00:00Z"
      }
    ]
  }
}
```

### 3. 下载题库

```http
GET /api/banks/:id/download
```

**参数**:
- `id`: 题库ID（例如：demo_bank、cn_subject1_v1）

**响应**: 返回题库JSON文件

**题库数据结构**:

```json
{
  "id": "demo_bank",
  "name": "示例题库",
  "version": "1.0.0",
  "total_questions": 50,
  "questions": [
    {
      "id": "demo_001",
      "type": "single",
      "question": "题目内容...",
      "options": ["选项A", "选项B", "选项C", "选项D"],
      "answer": [1],
      "explanation": "解析内容...",
      "chapter": "章节名称"
    }
  ]
}
```

**题型类型**:
- `single`: 单选题（4个选项，答案为单个索引）
- `multiple`: 多选题（4个选项，答案为多个索引数组）
- `judge`: 判断题（2个选项，答案为单个索引）

## Mock数据说明

### Demo题库 (demo_bank.json)
- **题目数量**: 50题
- **题型分布**: 
  - 单选题：30题
  - 多选题：10题
  - 判断题：10题
- **内容**: 涵盖交通法规、安全驾驶知识等

### 科目一题库 (cn_subject1_v1.json)
- **题目数量**: 10题（示例）
- **题型分布**: 
  - 单选题：6题
  - 多选题：2题
  - 判断题：2题
- **内容**: 科目一理论考试题目示例

## 开发

### 添加新题库

1. 在 `data/banks/` 目录下创建新的JSON文件
2. 在 `data/banks.json` 中添加题库元数据
3. 重启服务即可

### 题库数据格式

参考 `data/banks/demo_bank.json` 的格式创建新题库。

## 测试

### 单元测试（推荐）

```bash
# 运行所有单元测试
chmod +x run_tests.sh
./run_tests.sh

# 或者直接运行
go test ./... -v

# 查看测试覆盖率
go test ./... -cover

# 生成覆盖率报告
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out -o coverage.html
open coverage.html

# 运行性能测试
go test ./... -bench=. -benchmem
```

详细测试文档请查看：`TEST_README.md`

### API接口测试

#### 使用浏览器

访问以下URL：
- http://localhost:8080/api/health
- http://localhost:8080/api/banks

#### 使用 curl

```bash
# 测试健康检查
curl http://localhost:8080/api/health

# 测试题库列表
curl http://localhost:8080/api/banks | jq

# 测试下载题库
curl http://localhost:8080/api/banks/demo_bank/download | jq
```

## 已完成的功能

- ✅ 健康检查接口
- ✅ 题库列表接口
- ✅ 题库下载接口
- ✅ Mock数据（Demo题库50题 + 科目一10题）
- ✅ CORS配置（允许跨域）
- ✅ 错误处理
- ✅ 日志输出
- ✅ 完整的题库数据结构
- ✅ **完整的单元测试**（覆盖率 > 85%）

## 下一步计划

后端已基本完成，可以开始前端开发了！

建议后续扩展：
- [ ] 增加更多题库数据（完整的科目一1500题）
- [ ] 添加题库搜索功能
- [ ] 添加题库统计接口
- [ ] 部署到服务器

## 环境变量

复制 `.env.example` 为 `.env`：

```bash
cp .env.example .env
```

可配置项：
- `PORT`: 服务端口（默认8080）
- `GIN_MODE`: 运行模式（development/release）

## 部署

### 本地运行

```bash
go run main.go
```

### 编译运行

```bash
go build -o quiz-backend
./quiz-backend
```

### Docker 部署（可选）

```bash
docker build -t driving-quiz-backend .
docker run -p 8080:8080 driving-quiz-backend
```

## 许可证

MIT
