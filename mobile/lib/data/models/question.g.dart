// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String,
      type: json['type'] as String,
      question: json['question'] as String,
      image: json['image'] as String?,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      answer: (json['answer'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      explanation: json['explanation'] as String?,
      chapter: json['chapter'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'question': instance.question,
      'image': instance.image,
      'options': instance.options,
      'answer': instance.answer,
      'explanation': instance.explanation,
      'chapter': instance.chapter,
    };
