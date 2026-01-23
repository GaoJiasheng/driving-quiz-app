// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $QuestionBanksTable extends QuestionBanks
    with TableInfo<$QuestionBanksTable, QuestionBank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionBanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalQuestionsMeta =
      const VerificationMeta('totalQuestions');
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
      'total_questions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
      'downloaded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, version, totalQuestions, language, downloadedAt, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_banks';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionBank> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
          _totalQuestionsMeta,
          totalQuestions.isAcceptableOrUnknown(
              data['total_questions']!, _totalQuestionsMeta));
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionBank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionBank(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      totalQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_questions'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      downloadedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}downloaded_at'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $QuestionBanksTable createAlias(String alias) {
    return $QuestionBanksTable(attachedDatabase, alias);
  }
}

class QuestionBank extends DataClass implements Insertable<QuestionBank> {
  /// 题库ID（主键）
  final String id;

  /// 题库名称
  final String name;

  /// 版本号
  final String version;

  /// 题目总数
  final int totalQuestions;

  /// 语言
  final String language;

  /// 下载时间
  final DateTime downloadedAt;

  /// 题库数据（JSON格式存储完整题目）
  final String data;
  const QuestionBank(
      {required this.id,
      required this.name,
      required this.version,
      required this.totalQuestions,
      required this.language,
      required this.downloadedAt,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['language'] = Variable<String>(language);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    map['data'] = Variable<String>(data);
    return map;
  }

  QuestionBanksCompanion toCompanion(bool nullToAbsent) {
    return QuestionBanksCompanion(
      id: Value(id),
      name: Value(name),
      version: Value(version),
      totalQuestions: Value(totalQuestions),
      language: Value(language),
      downloadedAt: Value(downloadedAt),
      data: Value(data),
    );
  }

  factory QuestionBank.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionBank(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<String>(json['version']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      language: serializer.fromJson<String>(json['language']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<String>(version),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'language': serializer.toJson<String>(language),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
      'data': serializer.toJson<String>(data),
    };
  }

  QuestionBank copyWith(
          {String? id,
          String? name,
          String? version,
          int? totalQuestions,
          String? language,
          DateTime? downloadedAt,
          String? data}) =>
      QuestionBank(
        id: id ?? this.id,
        name: name ?? this.name,
        version: version ?? this.version,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        language: language ?? this.language,
        downloadedAt: downloadedAt ?? this.downloadedAt,
        data: data ?? this.data,
      );
  QuestionBank copyWithCompanion(QuestionBanksCompanion data) {
    return QuestionBank(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      language: data.language.present ? data.language.value : this.language,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionBank(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('language: $language, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, version, totalQuestions, language, downloadedAt, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionBank &&
          other.id == this.id &&
          other.name == this.name &&
          other.version == this.version &&
          other.totalQuestions == this.totalQuestions &&
          other.language == this.language &&
          other.downloadedAt == this.downloadedAt &&
          other.data == this.data);
}

class QuestionBanksCompanion extends UpdateCompanion<QuestionBank> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> version;
  final Value<int> totalQuestions;
  final Value<String> language;
  final Value<DateTime> downloadedAt;
  final Value<String> data;
  final Value<int> rowid;
  const QuestionBanksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.language = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionBanksCompanion.insert({
    required String id,
    required String name,
    required String version,
    required int totalQuestions,
    required String language,
    required DateTime downloadedAt,
    required String data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        version = Value(version),
        totalQuestions = Value(totalQuestions),
        language = Value(language),
        downloadedAt = Value(downloadedAt),
        data = Value(data);
  static Insertable<QuestionBank> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? version,
    Expression<int>? totalQuestions,
    Expression<String>? language,
    Expression<DateTime>? downloadedAt,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (language != null) 'language': language,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionBanksCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? version,
      Value<int>? totalQuestions,
      Value<String>? language,
      Value<DateTime>? downloadedAt,
      Value<String>? data,
      Value<int>? rowid}) {
    return QuestionBanksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      language: language ?? this.language,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionBanksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('language: $language, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnswerRecordsTable extends AnswerRecords
    with TableInfo<$AnswerRecordsTable, AnswerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnswerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userAnswerMeta =
      const VerificationMeta('userAnswer');
  @override
  late final GeneratedColumn<String> userAnswer = GeneratedColumn<String>(
      'user_answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bankId, questionId, userAnswer, isCorrect, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'answer_records';
  @override
  VerificationContext validateIntegrity(Insertable<AnswerRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('user_answer')) {
      context.handle(
          _userAnswerMeta,
          userAnswer.isAcceptableOrUnknown(
              data['user_answer']!, _userAnswerMeta));
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bankId, questionId},
      ];
  @override
  AnswerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnswerRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      userAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_answer']),
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $AnswerRecordsTable createAlias(String alias) {
    return $AnswerRecordsTable(attachedDatabase, alias);
  }
}

class AnswerRecord extends DataClass implements Insertable<AnswerRecord> {
  /// 记录ID（自增主键）
  final int id;

  /// 题库ID
  final String bankId;

  /// 题目ID
  final String questionId;

  /// 用户答案（JSON数组，如 [0,1] 表示选择了A和B）
  final String? userAnswer;

  /// 是否正确
  final bool isCorrect;

  /// 答题时间
  final DateTime answeredAt;
  const AnswerRecord(
      {required this.id,
      required this.bankId,
      required this.questionId,
      this.userAnswer,
      required this.isCorrect,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['question_id'] = Variable<String>(questionId);
    if (!nullToAbsent || userAnswer != null) {
      map['user_answer'] = Variable<String>(userAnswer);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  AnswerRecordsCompanion toCompanion(bool nullToAbsent) {
    return AnswerRecordsCompanion(
      id: Value(id),
      bankId: Value(bankId),
      questionId: Value(questionId),
      userAnswer: userAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(userAnswer),
      isCorrect: Value(isCorrect),
      answeredAt: Value(answeredAt),
    );
  }

  factory AnswerRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnswerRecord(
      id: serializer.fromJson<int>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      userAnswer: serializer.fromJson<String?>(json['userAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankId': serializer.toJson<String>(bankId),
      'questionId': serializer.toJson<String>(questionId),
      'userAnswer': serializer.toJson<String?>(userAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  AnswerRecord copyWith(
          {int? id,
          String? bankId,
          String? questionId,
          Value<String?> userAnswer = const Value.absent(),
          bool? isCorrect,
          DateTime? answeredAt}) =>
      AnswerRecord(
        id: id ?? this.id,
        bankId: bankId ?? this.bankId,
        questionId: questionId ?? this.questionId,
        userAnswer: userAnswer.present ? userAnswer.value : this.userAnswer,
        isCorrect: isCorrect ?? this.isCorrect,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  AnswerRecord copyWithCompanion(AnswerRecordsCompanion data) {
    return AnswerRecord(
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      userAnswer:
          data.userAnswer.present ? data.userAnswer.value : this.userAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnswerRecord(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bankId, questionId, userAnswer, isCorrect, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnswerRecord &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.questionId == this.questionId &&
          other.userAnswer == this.userAnswer &&
          other.isCorrect == this.isCorrect &&
          other.answeredAt == this.answeredAt);
}

class AnswerRecordsCompanion extends UpdateCompanion<AnswerRecord> {
  final Value<int> id;
  final Value<String> bankId;
  final Value<String> questionId;
  final Value<String?> userAnswer;
  final Value<bool> isCorrect;
  final Value<DateTime> answeredAt;
  const AnswerRecordsCompanion({
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  AnswerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String bankId,
    required String questionId,
    this.userAnswer = const Value.absent(),
    required bool isCorrect,
    required DateTime answeredAt,
  })  : bankId = Value(bankId),
        questionId = Value(questionId),
        isCorrect = Value(isCorrect),
        answeredAt = Value(answeredAt);
  static Insertable<AnswerRecord> custom({
    Expression<int>? id,
    Expression<String>? bankId,
    Expression<String>? questionId,
    Expression<String>? userAnswer,
    Expression<bool>? isCorrect,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (questionId != null) 'question_id': questionId,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  AnswerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankId,
      Value<String>? questionId,
      Value<String?>? userAnswer,
      Value<bool>? isCorrect,
      Value<DateTime>? answeredAt}) {
    return AnswerRecordsCompanion(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      questionId: questionId ?? this.questionId,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (userAnswer.present) {
      map['user_answer'] = Variable<String>(userAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnswerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

class $BankProgressTable extends BankProgress
    with TableInfo<$BankProgressTable, BankProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentIndexMeta =
      const VerificationMeta('currentIndex');
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
      'current_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalAnsweredMeta =
      const VerificationMeta('totalAnswered');
  @override
  late final GeneratedColumn<int> totalAnswered = GeneratedColumn<int>(
      'total_answered', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalCorrectMeta =
      const VerificationMeta('totalCorrect');
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
      'total_correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [bankId, currentIndex, totalAnswered, totalCorrect, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_progress';
  @override
  VerificationContext validateIntegrity(Insertable<BankProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
          _currentIndexMeta,
          currentIndex.isAcceptableOrUnknown(
              data['current_index']!, _currentIndexMeta));
    }
    if (data.containsKey('total_answered')) {
      context.handle(
          _totalAnsweredMeta,
          totalAnswered.isAcceptableOrUnknown(
              data['total_answered']!, _totalAnsweredMeta));
    }
    if (data.containsKey('total_correct')) {
      context.handle(
          _totalCorrectMeta,
          totalCorrect.isAcceptableOrUnknown(
              data['total_correct']!, _totalCorrectMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bankId};
  @override
  BankProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankProgressData(
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id'])!,
      currentIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_index'])!,
      totalAnswered: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_answered'])!,
      totalCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_correct'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BankProgressTable createAlias(String alias) {
    return $BankProgressTable(attachedDatabase, alias);
  }
}

class BankProgressData extends DataClass
    implements Insertable<BankProgressData> {
  /// 题库ID（主键）
  final String bankId;

  /// 顺序模式：当前题目索引
  final int currentIndex;

  /// 已答题总数
  final int totalAnswered;

  /// 答对题数
  final int totalCorrect;

  /// 最后更新时间
  final DateTime updatedAt;
  const BankProgressData(
      {required this.bankId,
      required this.currentIndex,
      required this.totalAnswered,
      required this.totalCorrect,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bank_id'] = Variable<String>(bankId);
    map['current_index'] = Variable<int>(currentIndex);
    map['total_answered'] = Variable<int>(totalAnswered);
    map['total_correct'] = Variable<int>(totalCorrect);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BankProgressCompanion toCompanion(bool nullToAbsent) {
    return BankProgressCompanion(
      bankId: Value(bankId),
      currentIndex: Value(currentIndex),
      totalAnswered: Value(totalAnswered),
      totalCorrect: Value(totalCorrect),
      updatedAt: Value(updatedAt),
    );
  }

  factory BankProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankProgressData(
      bankId: serializer.fromJson<String>(json['bankId']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      totalAnswered: serializer.fromJson<int>(json['totalAnswered']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bankId': serializer.toJson<String>(bankId),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'totalAnswered': serializer.toJson<int>(totalAnswered),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BankProgressData copyWith(
          {String? bankId,
          int? currentIndex,
          int? totalAnswered,
          int? totalCorrect,
          DateTime? updatedAt}) =>
      BankProgressData(
        bankId: bankId ?? this.bankId,
        currentIndex: currentIndex ?? this.currentIndex,
        totalAnswered: totalAnswered ?? this.totalAnswered,
        totalCorrect: totalCorrect ?? this.totalCorrect,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BankProgressData copyWithCompanion(BankProgressCompanion data) {
    return BankProgressData(
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      totalAnswered: data.totalAnswered.present
          ? data.totalAnswered.value
          : this.totalAnswered,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankProgressData(')
          ..write('bankId: $bankId, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('totalAnswered: $totalAnswered, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bankId, currentIndex, totalAnswered, totalCorrect, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankProgressData &&
          other.bankId == this.bankId &&
          other.currentIndex == this.currentIndex &&
          other.totalAnswered == this.totalAnswered &&
          other.totalCorrect == this.totalCorrect &&
          other.updatedAt == this.updatedAt);
}

class BankProgressCompanion extends UpdateCompanion<BankProgressData> {
  final Value<String> bankId;
  final Value<int> currentIndex;
  final Value<int> totalAnswered;
  final Value<int> totalCorrect;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BankProgressCompanion({
    this.bankId = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.totalAnswered = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BankProgressCompanion.insert({
    required String bankId,
    this.currentIndex = const Value.absent(),
    this.totalAnswered = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : bankId = Value(bankId),
        updatedAt = Value(updatedAt);
  static Insertable<BankProgressData> custom({
    Expression<String>? bankId,
    Expression<int>? currentIndex,
    Expression<int>? totalAnswered,
    Expression<int>? totalCorrect,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bankId != null) 'bank_id': bankId,
      if (currentIndex != null) 'current_index': currentIndex,
      if (totalAnswered != null) 'total_answered': totalAnswered,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BankProgressCompanion copyWith(
      {Value<String>? bankId,
      Value<int>? currentIndex,
      Value<int>? totalAnswered,
      Value<int>? totalCorrect,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BankProgressCompanion(
      bankId: bankId ?? this.bankId,
      currentIndex: currentIndex ?? this.currentIndex,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (totalAnswered.present) {
      map['total_answered'] = Variable<int>(totalAnswered.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankProgressCompanion(')
          ..write('bankId: $bankId, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('totalAnswered: $totalAnswered, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WrongQuestionsTable extends WrongQuestions
    with TableInfo<$WrongQuestionsTable, WrongQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WrongQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isMasteredMeta =
      const VerificationMeta('isMastered');
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
      'is_mastered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_mastered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bankId, questionId, isMastered, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wrong_questions';
  @override
  VerificationContext validateIntegrity(Insertable<WrongQuestion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
          _isMasteredMeta,
          isMastered.isAcceptableOrUnknown(
              data['is_mastered']!, _isMasteredMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bankId, questionId},
      ];
  @override
  WrongQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WrongQuestion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      isMastered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mastered'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $WrongQuestionsTable createAlias(String alias) {
    return $WrongQuestionsTable(attachedDatabase, alias);
  }
}

class WrongQuestion extends DataClass implements Insertable<WrongQuestion> {
  /// 记录ID（自增主键）
  final int id;

  /// 题库ID
  final String bankId;

  /// 题目ID
  final String questionId;

  /// 是否已掌握
  final bool isMastered;

  /// 加入错题本的时间
  final DateTime addedAt;
  const WrongQuestion(
      {required this.id,
      required this.bankId,
      required this.questionId,
      required this.isMastered,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['question_id'] = Variable<String>(questionId);
    map['is_mastered'] = Variable<bool>(isMastered);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WrongQuestionsCompanion toCompanion(bool nullToAbsent) {
    return WrongQuestionsCompanion(
      id: Value(id),
      bankId: Value(bankId),
      questionId: Value(questionId),
      isMastered: Value(isMastered),
      addedAt: Value(addedAt),
    );
  }

  factory WrongQuestion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WrongQuestion(
      id: serializer.fromJson<int>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankId': serializer.toJson<String>(bankId),
      'questionId': serializer.toJson<String>(questionId),
      'isMastered': serializer.toJson<bool>(isMastered),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WrongQuestion copyWith(
          {int? id,
          String? bankId,
          String? questionId,
          bool? isMastered,
          DateTime? addedAt}) =>
      WrongQuestion(
        id: id ?? this.id,
        bankId: bankId ?? this.bankId,
        questionId: questionId ?? this.questionId,
        isMastered: isMastered ?? this.isMastered,
        addedAt: addedAt ?? this.addedAt,
      );
  WrongQuestion copyWithCompanion(WrongQuestionsCompanion data) {
    return WrongQuestion(
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      isMastered:
          data.isMastered.present ? data.isMastered.value : this.isMastered,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WrongQuestion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('isMastered: $isMastered, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bankId, questionId, isMastered, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WrongQuestion &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.questionId == this.questionId &&
          other.isMastered == this.isMastered &&
          other.addedAt == this.addedAt);
}

class WrongQuestionsCompanion extends UpdateCompanion<WrongQuestion> {
  final Value<int> id;
  final Value<String> bankId;
  final Value<String> questionId;
  final Value<bool> isMastered;
  final Value<DateTime> addedAt;
  const WrongQuestionsCompanion({
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  WrongQuestionsCompanion.insert({
    this.id = const Value.absent(),
    required String bankId,
    required String questionId,
    this.isMastered = const Value.absent(),
    required DateTime addedAt,
  })  : bankId = Value(bankId),
        questionId = Value(questionId),
        addedAt = Value(addedAt);
  static Insertable<WrongQuestion> custom({
    Expression<int>? id,
    Expression<String>? bankId,
    Expression<String>? questionId,
    Expression<bool>? isMastered,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (questionId != null) 'question_id': questionId,
      if (isMastered != null) 'is_mastered': isMastered,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  WrongQuestionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankId,
      Value<String>? questionId,
      Value<bool>? isMastered,
      Value<DateTime>? addedAt}) {
    return WrongQuestionsCompanion(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      questionId: questionId ?? this.questionId,
      isMastered: isMastered ?? this.isMastered,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WrongQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('isMastered: $isMastered, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, bankId, questionId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bankId, questionId},
      ];
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  /// 记录ID（自增主键）
  final int id;

  /// 题库ID
  final String bankId;

  /// 题目ID
  final String questionId;

  /// 收藏时间
  final DateTime createdAt;
  const Favorite(
      {required this.id,
      required this.bankId,
      required this.questionId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['question_id'] = Variable<String>(questionId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      bankId: Value(bankId),
      questionId: Value(questionId),
      createdAt: Value(createdAt),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankId': serializer.toJson<String>(bankId),
      'questionId': serializer.toJson<String>(questionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Favorite copyWith(
          {int? id, String? bankId, String? questionId, DateTime? createdAt}) =>
      Favorite(
        id: id ?? this.id,
        bankId: bankId ?? this.bankId,
        questionId: questionId ?? this.questionId,
        createdAt: createdAt ?? this.createdAt,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bankId, questionId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.questionId == this.questionId &&
          other.createdAt == this.createdAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> bankId;
  final Value<String> questionId;
  final Value<DateTime> createdAt;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String bankId,
    required String questionId,
    required DateTime createdAt,
  })  : bankId = Value(bankId),
        questionId = Value(questionId),
        createdAt = Value(createdAt);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? bankId,
    Expression<String>? questionId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (questionId != null) 'question_id': questionId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankId,
      Value<String>? questionId,
      Value<DateTime>? createdAt}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      questionId: questionId ?? this.questionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('questionId: $questionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionBanksTable questionBanks = $QuestionBanksTable(this);
  late final $AnswerRecordsTable answerRecords = $AnswerRecordsTable(this);
  late final $BankProgressTable bankProgress = $BankProgressTable(this);
  late final $WrongQuestionsTable wrongQuestions = $WrongQuestionsTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [questionBanks, answerRecords, bankProgress, wrongQuestions, favorites];
}

typedef $$QuestionBanksTableCreateCompanionBuilder = QuestionBanksCompanion
    Function({
  required String id,
  required String name,
  required String version,
  required int totalQuestions,
  required String language,
  required DateTime downloadedAt,
  required String data,
  Value<int> rowid,
});
typedef $$QuestionBanksTableUpdateCompanionBuilder = QuestionBanksCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> version,
  Value<int> totalQuestions,
  Value<String> language,
  Value<DateTime> downloadedAt,
  Value<String> data,
  Value<int> rowid,
});

class $$QuestionBanksTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionBanksTable> {
  $$QuestionBanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$QuestionBanksTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionBanksTable> {
  $$QuestionBanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$QuestionBanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionBanksTable> {
  $$QuestionBanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$QuestionBanksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionBanksTable,
    QuestionBank,
    $$QuestionBanksTableFilterComposer,
    $$QuestionBanksTableOrderingComposer,
    $$QuestionBanksTableAnnotationComposer,
    $$QuestionBanksTableCreateCompanionBuilder,
    $$QuestionBanksTableUpdateCompanionBuilder,
    (
      QuestionBank,
      BaseReferences<_$AppDatabase, $QuestionBanksTable, QuestionBank>
    ),
    QuestionBank,
    PrefetchHooks Function()> {
  $$QuestionBanksTableTableManager(_$AppDatabase db, $QuestionBanksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionBanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionBanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionBanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<int> totalQuestions = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<DateTime> downloadedAt = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionBanksCompanion(
            id: id,
            name: name,
            version: version,
            totalQuestions: totalQuestions,
            language: language,
            downloadedAt: downloadedAt,
            data: data,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String version,
            required int totalQuestions,
            required String language,
            required DateTime downloadedAt,
            required String data,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionBanksCompanion.insert(
            id: id,
            name: name,
            version: version,
            totalQuestions: totalQuestions,
            language: language,
            downloadedAt: downloadedAt,
            data: data,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionBanksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionBanksTable,
    QuestionBank,
    $$QuestionBanksTableFilterComposer,
    $$QuestionBanksTableOrderingComposer,
    $$QuestionBanksTableAnnotationComposer,
    $$QuestionBanksTableCreateCompanionBuilder,
    $$QuestionBanksTableUpdateCompanionBuilder,
    (
      QuestionBank,
      BaseReferences<_$AppDatabase, $QuestionBanksTable, QuestionBank>
    ),
    QuestionBank,
    PrefetchHooks Function()>;
typedef $$AnswerRecordsTableCreateCompanionBuilder = AnswerRecordsCompanion
    Function({
  Value<int> id,
  required String bankId,
  required String questionId,
  Value<String?> userAnswer,
  required bool isCorrect,
  required DateTime answeredAt,
});
typedef $$AnswerRecordsTableUpdateCompanionBuilder = AnswerRecordsCompanion
    Function({
  Value<int> id,
  Value<String> bankId,
  Value<String> questionId,
  Value<String?> userAnswer,
  Value<bool> isCorrect,
  Value<DateTime> answeredAt,
});

class $$AnswerRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$AnswerRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$AnswerRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$AnswerRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnswerRecordsTable,
    AnswerRecord,
    $$AnswerRecordsTableFilterComposer,
    $$AnswerRecordsTableOrderingComposer,
    $$AnswerRecordsTableAnnotationComposer,
    $$AnswerRecordsTableCreateCompanionBuilder,
    $$AnswerRecordsTableUpdateCompanionBuilder,
    (
      AnswerRecord,
      BaseReferences<_$AppDatabase, $AnswerRecordsTable, AnswerRecord>
    ),
    AnswerRecord,
    PrefetchHooks Function()> {
  $$AnswerRecordsTableTableManager(_$AppDatabase db, $AnswerRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnswerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnswerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnswerRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bankId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<String?> userAnswer = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
          }) =>
              AnswerRecordsCompanion(
            id: id,
            bankId: bankId,
            questionId: questionId,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            answeredAt: answeredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bankId,
            required String questionId,
            Value<String?> userAnswer = const Value.absent(),
            required bool isCorrect,
            required DateTime answeredAt,
          }) =>
              AnswerRecordsCompanion.insert(
            id: id,
            bankId: bankId,
            questionId: questionId,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            answeredAt: answeredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnswerRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnswerRecordsTable,
    AnswerRecord,
    $$AnswerRecordsTableFilterComposer,
    $$AnswerRecordsTableOrderingComposer,
    $$AnswerRecordsTableAnnotationComposer,
    $$AnswerRecordsTableCreateCompanionBuilder,
    $$AnswerRecordsTableUpdateCompanionBuilder,
    (
      AnswerRecord,
      BaseReferences<_$AppDatabase, $AnswerRecordsTable, AnswerRecord>
    ),
    AnswerRecord,
    PrefetchHooks Function()>;
typedef $$BankProgressTableCreateCompanionBuilder = BankProgressCompanion
    Function({
  required String bankId,
  Value<int> currentIndex,
  Value<int> totalAnswered,
  Value<int> totalCorrect,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BankProgressTableUpdateCompanionBuilder = BankProgressCompanion
    Function({
  Value<String> bankId,
  Value<int> currentIndex,
  Value<int> totalAnswered,
  Value<int> totalCorrect,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BankProgressTableFilterComposer
    extends Composer<_$AppDatabase, $BankProgressTable> {
  $$BankProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentIndex => $composableBuilder(
      column: $table.currentIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAnswered => $composableBuilder(
      column: $table.totalAnswered, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BankProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $BankProgressTable> {
  $$BankProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentIndex => $composableBuilder(
      column: $table.currentIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAnswered => $composableBuilder(
      column: $table.totalAnswered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BankProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankProgressTable> {
  $$BankProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<int> get currentIndex => $composableBuilder(
      column: $table.currentIndex, builder: (column) => column);

  GeneratedColumn<int> get totalAnswered => $composableBuilder(
      column: $table.totalAnswered, builder: (column) => column);

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BankProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BankProgressTable,
    BankProgressData,
    $$BankProgressTableFilterComposer,
    $$BankProgressTableOrderingComposer,
    $$BankProgressTableAnnotationComposer,
    $$BankProgressTableCreateCompanionBuilder,
    $$BankProgressTableUpdateCompanionBuilder,
    (
      BankProgressData,
      BaseReferences<_$AppDatabase, $BankProgressTable, BankProgressData>
    ),
    BankProgressData,
    PrefetchHooks Function()> {
  $$BankProgressTableTableManager(_$AppDatabase db, $BankProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> bankId = const Value.absent(),
            Value<int> currentIndex = const Value.absent(),
            Value<int> totalAnswered = const Value.absent(),
            Value<int> totalCorrect = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BankProgressCompanion(
            bankId: bankId,
            currentIndex: currentIndex,
            totalAnswered: totalAnswered,
            totalCorrect: totalCorrect,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String bankId,
            Value<int> currentIndex = const Value.absent(),
            Value<int> totalAnswered = const Value.absent(),
            Value<int> totalCorrect = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BankProgressCompanion.insert(
            bankId: bankId,
            currentIndex: currentIndex,
            totalAnswered: totalAnswered,
            totalCorrect: totalCorrect,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BankProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BankProgressTable,
    BankProgressData,
    $$BankProgressTableFilterComposer,
    $$BankProgressTableOrderingComposer,
    $$BankProgressTableAnnotationComposer,
    $$BankProgressTableCreateCompanionBuilder,
    $$BankProgressTableUpdateCompanionBuilder,
    (
      BankProgressData,
      BaseReferences<_$AppDatabase, $BankProgressTable, BankProgressData>
    ),
    BankProgressData,
    PrefetchHooks Function()>;
typedef $$WrongQuestionsTableCreateCompanionBuilder = WrongQuestionsCompanion
    Function({
  Value<int> id,
  required String bankId,
  required String questionId,
  Value<bool> isMastered,
  required DateTime addedAt,
});
typedef $$WrongQuestionsTableUpdateCompanionBuilder = WrongQuestionsCompanion
    Function({
  Value<int> id,
  Value<String> bankId,
  Value<String> questionId,
  Value<bool> isMastered,
  Value<DateTime> addedAt,
});

class $$WrongQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));
}

class $$WrongQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));
}

class $$WrongQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WrongQuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WrongQuestionsTable,
    WrongQuestion,
    $$WrongQuestionsTableFilterComposer,
    $$WrongQuestionsTableOrderingComposer,
    $$WrongQuestionsTableAnnotationComposer,
    $$WrongQuestionsTableCreateCompanionBuilder,
    $$WrongQuestionsTableUpdateCompanionBuilder,
    (
      WrongQuestion,
      BaseReferences<_$AppDatabase, $WrongQuestionsTable, WrongQuestion>
    ),
    WrongQuestion,
    PrefetchHooks Function()> {
  $$WrongQuestionsTableTableManager(
      _$AppDatabase db, $WrongQuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WrongQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WrongQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WrongQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bankId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<bool> isMastered = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              WrongQuestionsCompanion(
            id: id,
            bankId: bankId,
            questionId: questionId,
            isMastered: isMastered,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bankId,
            required String questionId,
            Value<bool> isMastered = const Value.absent(),
            required DateTime addedAt,
          }) =>
              WrongQuestionsCompanion.insert(
            id: id,
            bankId: bankId,
            questionId: questionId,
            isMastered: isMastered,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WrongQuestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WrongQuestionsTable,
    WrongQuestion,
    $$WrongQuestionsTableFilterComposer,
    $$WrongQuestionsTableOrderingComposer,
    $$WrongQuestionsTableAnnotationComposer,
    $$WrongQuestionsTableCreateCompanionBuilder,
    $$WrongQuestionsTableUpdateCompanionBuilder,
    (
      WrongQuestion,
      BaseReferences<_$AppDatabase, $WrongQuestionsTable, WrongQuestion>
    ),
    WrongQuestion,
    PrefetchHooks Function()>;
typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  required String bankId,
  required String questionId,
  required DateTime createdAt,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  Value<String> bankId,
  Value<String> questionId,
  Value<DateTime> createdAt,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bankId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoritesCompanion(
            id: id,
            bankId: bankId,
            questionId: questionId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bankId,
            required String questionId,
            required DateTime createdAt,
          }) =>
              FavoritesCompanion.insert(
            id: id,
            bankId: bankId,
            questionId: questionId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionBanksTableTableManager get questionBanks =>
      $$QuestionBanksTableTableManager(_db, _db.questionBanks);
  $$AnswerRecordsTableTableManager get answerRecords =>
      $$AnswerRecordsTableTableManager(_db, _db.answerRecords);
  $$BankProgressTableTableManager get bankProgress =>
      $$BankProgressTableTableManager(_db, _db.bankProgress);
  $$WrongQuestionsTableTableManager get wrongQuestions =>
      $$WrongQuestionsTableTableManager(_db, _db.wrongQuestions);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
}
