# API 文档

DriveQuiz 后端 API 接口文档

**Base URL**: `http://localhost:8080`

**API Version**: v1

---

## 通用说明

### 请求头

```
Content-Type: application/json
```

### 响应格式

所有 API 响应采用统一格式：

**成功响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": { ... }
}
```

**错误响应**:
```json
{
  "code": 400,
  "message": "错误描述",
  "error": "详细错误信息"
}
```

### HTTP 状态码

| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

## API 端点

### 1. 健康检查

检查服务是否正常运行。

**请求**

```
GET /api/health
```

**响应**

```json
{
  "status": "ok",
  "message": "DriveQuiz Backend API is running"
}
```

---

### 2. 获取题库列表

获取所有可用题库的列表信息。

**请求**

```
GET /api/banks
```

**查询参数**

无

**响应**

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
        "download_url": "http://localhost:8080/api/banks/demo_bank/download",
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
        "download_url": "http://localhost:8080/api/banks/cn_subject1_v1/download",
        "updated_at": "2026-01-23T10:00:00Z"
      }
    ]
  }
}
```

**字段说明**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | string | 题库唯一标识 |
| name | string | 题库名称 |
| description | string | 题库描述 |
| total_questions | number | 题目总数 |
| version | string | 版本号 |
| language | string | 语言代码 |
| size | number | 文件大小（字节） |
| download_url | string | 下载地址 |
| updated_at | string | 更新时间 (ISO 8601) |

---

### 3. 下载题库

下载指定题库的完整数据。

**请求**

```
GET /api/banks/:id/download
```

**路径参数**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | string | 题库ID |

**示例**

```
GET /api/banks/cn_subject1_v1/download
```

**响应**

直接返回题库 JSON 文件，格式如下：

```json
{
  "id": "cn_subject1_v1",
  "name": "中国驾照科目一",
  "version": "1.0.0",
  "description": "科目一理论考试题库",
  "total_questions": 1500,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-23T10:00:00Z",
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
      "explanation": "违反道路交通安全法的行为属于违法行为。",
      "chapter": "道路交通安全法律法规"
    }
    // ... 更多题目
  ]
}
```

**响应头**

```
Content-Type: application/json
Content-Disposition: attachment; filename=cn_subject1_v1.json
```

**错误响应**

```json
{
  "code": 404,
  "message": "Bank not found",
  "error": "题库不存在"
}
```

---

## 错误码说明

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| 404 | 题库不存在 | 检查题库ID是否正确 |
| 500 | 服务器错误 | 联系管理员 |

---

## 调用示例

### cURL

```bash
# 健康检查
curl http://localhost:8080/api/health

# 获取题库列表
curl http://localhost:8080/api/banks

# 下载题库
curl http://localhost:8080/api/banks/cn_subject1_v1/download -o subject1.json
```

### JavaScript (Fetch)

```javascript
// 获取题库列表
fetch('http://localhost:8080/api/banks')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));

// 下载题库
fetch('http://localhost:8080/api/banks/cn_subject1_v1/download')
  .then(response => response.blob())
  .then(blob => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'subject1.json';
    a.click();
  });
```

### Dart (Dio)

```dart
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'http://localhost:8080',
));

// 获取题库列表
Future<void> getBankList() async {
  try {
    final response = await dio.get('/api/banks');
    print(response.data);
  } catch (e) {
    print('Error: $e');
  }
}

// 下载题库
Future<void> downloadBank(String bankId) async {
  try {
    await dio.download(
      '/api/banks/$bankId/download',
      './data/$bankId.json',
      onReceiveProgress: (received, total) {
        print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## 未来API规划

### 版本检查 (计划中)

```
GET /api/banks/:id/version
```

检查题库是否有新版本。

### 题库搜索 (计划中)

```
GET /api/banks/search?q=keyword
```

搜索题库。

---

**文档更新时间**: 2026-01-23
