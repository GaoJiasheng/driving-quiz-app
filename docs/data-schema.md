# 数据结构文档

## 1. 题库数据结构

### 1.1 题库元数据（banks.json）

```json
{
  "banks": [
    {
      "id": "string",              // 题库唯一标识
      "name": "string",            // 题库名称
      "description": "string",     // 题库描述
      "total_questions": "number", // 题目总数
      "version": "string",         // 版本号（如 "1.0.0"）
      "language": "string",        // 语言代码（如 "zh-CN"）
      "size": "number",            // 文件大小（字节）
      "updated_at": "string"       // 更新时间（ISO 8601格式）
    }
  ]
}
```

**示例**：
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
      "updated_at": "2026-01-23T10:00:00Z"
    }
  ]
}
```

### 1.2 题库完整数据

```json
{
  "id": "string",              // 题库ID
  "name": "string",            // 题库名称
  "version": "string",         // 版本号
  "description": "string",     // 描述
  "total_questions": "number", // 题目总数
  "created_at": "string",      // 创建时间
  "updated_at": "string",      // 更新时间
  "language": "string",        // 语言
  "questions": [               // 题目列表
    {
      "id": "string",          // 题目ID
      "type": "string",        // 题目类型：single | multiple | judge
      "question": "string",    // 题目内容
      "image": "string",       // 图片URL（可选）
      "options": ["string"],   // 选项列表
      "answer": [0, 1],        // 答案索引数组
      "explanation": "string", // 答案解析
      "chapter": "string"      // 所属章节（可选）
    }
  ]
}
```

**题目类型说明**：
- `single`: 单选题，4个选项，1个正确答案
- `multiple`: 多选题，4个选项，1-4个正确答案
- `judge`: 判断题，2个选项（正确/错误），1个正确答案

**示例题目**：

```json
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
```

---

## 2. 移动端数据库结构（SQLite）

### 2.1 题库表（question_banks）

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | TEXT | 题库ID | PRIMARY KEY |
| name | TEXT | 题库名称 | NOT NULL |
| version | TEXT | 版本号 | |
| total_questions | INTEGER | 题目总数 | |
| language | TEXT | 语言代码 | |
| downloaded_at | TIMESTAMP | 下载时间 | |
| data | TEXT | 题目数据（JSON） | |

### 2.2 答题记录表（answer_records）

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INTEGER | 自增ID | PRIMARY KEY |
| bank_id | TEXT | 题库ID | NOT NULL |
| question_id | TEXT | 题目ID | NOT NULL |
| user_answer | TEXT | 用户答案（JSON数组） | |
| is_correct | BOOLEAN | 是否正确 | |
| answered_at | TIMESTAMP | 答题时间 | |

### 2.3 题库进度表（bank_progress）

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| bank_id | TEXT | 题库ID | PRIMARY KEY |
| current_index | INTEGER | 当前位置（顺序模式） | DEFAULT 0 |
| total_answered | INTEGER | 已答题数 | DEFAULT 0 |
| total_correct | INTEGER | 答对题数 | DEFAULT 0 |

### 2.4 错题表（wrong_questions）

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INTEGER | 自增ID | PRIMARY KEY |
| bank_id | TEXT | 题库ID | NOT NULL |
| question_id | TEXT | 题目ID | NOT NULL |
| is_mastered | BOOLEAN | 是否已掌握 | DEFAULT FALSE |
| added_at | TIMESTAMP | 加入时间 | |
| | | | UNIQUE(bank_id, question_id) |

### 2.5 收藏表（favorites）

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INTEGER | 自增ID | PRIMARY KEY |
| bank_id | TEXT | 题库ID | NOT NULL |
| question_id | TEXT | 题目ID | NOT NULL |
| created_at | TIMESTAMP | 收藏时间 | |
| | | | UNIQUE(bank_id, question_id) |

---

## 3. API 响应格式

### 3.1 题库列表 API

**请求**: `GET /api/banks`

**响应**:
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
        "size": 5242880,
        "download_url": "http://localhost:8080/api/banks/cn_subject1_v1/download",
        "updated_at": "2026-01-23T10:00:00Z"
      }
    ]
  }
}
```

### 3.2 题库下载 API

**请求**: `GET /api/banks/:id/download`

**响应**: 题库JSON文件（直接下载）

---

## 4. 数据流转

```
┌─────────────┐
│   后端API   │
└──────┬──────┘
       │ HTTP
       ↓
┌─────────────┐
│  网络请求层  │ (Dio)
└──────┬──────┘
       │
       ↓
┌─────────────┐
│ Repository  │ (数据仓库)
└──────┬──────┘
       │
       ↓
┌─────────────┐
│  SQLite DB  │ (Drift)
└──────┬──────┘
       │
       ↓
┌─────────────┐
│   Provider  │ (Riverpod)
└──────┬──────┘
       │
       ↓
┌─────────────┐
│     UI      │
└─────────────┘
```

---

## 5. 数据验证规则

### 5.1 题库ID
- 格式：`[a-z0-9_]+`
- 示例：`cn_subject1_v1`

### 5.2 版本号
- 格式：`x.y.z`（语义化版本）
- 示例：`1.0.0`, `1.2.3`

### 5.3 题目ID
- 格式：题库内唯一
- 建议：`q001`, `q002`, ...

### 5.4 题目类型
- 枚举值：`single`, `multiple`, `judge`

### 5.5 答案索引
- 范围：`0 ~ options.length - 1`
- 单选题：1个元素
- 多选题：1-4个元素
- 判断题：1个元素（0或1）

---

## 6. 数据迁移策略

### 6.1 题库更新
- 检测版本号变化
- 保留用户答题记录
- 清理不存在题目的记录

### 6.2 数据导出
- 导出格式：JSON
- 包含：答题记录、错题、收藏
- 不包含：题库数据（可重新下载）

### 6.3 数据清除
- 清除所有答题记录
- 保留已下载题库
- 可选：同时删除题库

---

## 7. 性能优化

### 7.1 数据库索引
```sql
CREATE INDEX idx_answer_records_bank ON answer_records(bank_id);
CREATE INDEX idx_wrong_questions_bank ON wrong_questions(bank_id);
CREATE INDEX idx_favorites_bank ON favorites(bank_id);
```

### 7.2 数据分页
- 题目列表：按需加载
- 答题记录：限制查询范围

### 7.3 缓存策略
- 题库列表：内存缓存5分钟
- 当前题库：内存常驻
- 统计数据：按需计算，缓存1分钟
