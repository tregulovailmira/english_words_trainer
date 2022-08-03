// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WordModel _$$_WordModelFromJson(Map<String, dynamic> json) => _$_WordModel(
      id: json['id'] as int,
      userId: json['userId'] as String,
      englishWord: json['englishWord'] as String,
      translation: json['translation'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_WordModelToJson(_$_WordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'englishWord': instance.englishWord,
      'translation': instance.translation,
      'createdAt': instance.createdAt.toIso8601String(),
    };
