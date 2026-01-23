# 数据库层

## 📊 数据库结构

本应用使用 **Drift** 作为 SQLite ORM，包含5张表：

### 1. question_banks - 题库表
存储下载的题库数据
- `id`: 题库ID（主键）
- `name`: 题库名称
- `version`: 版本号
- `total_questions`: 题目总数
- `language`: 语言
- `downloaded_at`: 下载时间
- `data`: 完整题库数据（JSON）

### 2. answer_records - 答题记录表
记录每次答题的详细信息
- `id`: 记录ID（自增）
- `bank_id`: 题库ID
- `question_id`: 题目ID
- `user_answer`: 用户答案（JSON数组）
- `is_correct`: 是否正确
- `answered_at`: 答题时间

### 3. bank_progress - 题库进度表
追踪每个题库的刷题进度
- `bank_id`: 题库ID（主键）
- `current_index`: 当前题目索引
- `total_answered`: 已答题数
- `total_correct`: 答对题数
- `updated_at`: 更新时间

### 4. wrong_questions - 错题表
管理错题本
- `id`: 记录ID（自增）
- `bank_id`: 题库ID
- `question_id`: 题目ID
- `is_mastered`: 是否已掌握
- `added_at`: 加入时间

### 5. favorites - 收藏表
存储用户收藏的题目
- `id`: 记录ID（自增）
- `bank_id`: 题库ID
- `question_id`: 题目ID
- `created_at`: 收藏时间

## 🔧 代码生成

Drift 使用代码生成来创建数据库访问代码。

### 运行代码生成

```bash
cd mobile
flutter pub run build_runner build --delete-conflicting-outputs
```

### 监听模式（开发时使用）

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 🗄️ 使用示例

```dart
// 获取数据库实例
final database = AppDatabase();

// 查询所有题库
final banks = await database.select(database.questionBanks).get();

// 插入答题记录
await database.into(database.answerRecords).insert(
  AnswerRecordsCompanion.insert(
    bankId: 'demo_bank',
    questionId: 'q001',
    userAnswer: Value('[0]'),
    isCorrect: true,
    answeredAt: DateTime.now(),
  ),
);

// 更新进度
await database.update(database.bankProgress).replace(
  BankProgressCompanion(
    bankId: Value('demo_bank'),
    currentIndex: Value(5),
    totalAnswered: Value(5),
    totalCorrect: Value(4),
    updatedAt: Value(DateTime.now()),
  ),
);
```

## 📝 注意事项

1. **修改表结构后**必须重新运行代码生成
2. **database.g.dart** 文件是自动生成的，不要手动修改
3. 数据库文件位置：`应用文档目录/quiz_app.db`
4. 开发时可以使用 `AppDatabase.deleteDatabase()` 清空数据库
