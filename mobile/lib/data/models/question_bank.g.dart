// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionBank _$QuestionBankFromJson(Map<String, dynamic> json) => QuestionBank(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String?,
      totalQuestions: (json['total_questions'] as num).toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      language: json['language'] as String,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionBankToJson(QuestionBank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'description': instance.description,
      'total_questions': instance.totalQuestions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'language': instance.language,
      'questions': instance.questions,
    };

QuestionBankInfo _$QuestionBankInfoFromJson(Map<String, dynamic> json) =>
    QuestionBankInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      totalQuestions: (json['total_questions'] as num).toInt(),
      version: json['version'] as String,
      language: json['language'] as String,
      sizeBytes: (json['size'] as num?)?.toInt(),
      downloadUrl: json['download_url'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$QuestionBankInfoToJson(QuestionBankInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'total_questions': instance.totalQuestions,
      'version': instance.version,
      'language': instance.language,
      'size': instance.sizeBytes,
      'download_url': instance.downloadUrl,
      'updated_at': instance.updatedAt,
    };
