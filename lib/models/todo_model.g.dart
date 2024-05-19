// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoModelImpl _$$TodoModelImplFromJson(Map<String, dynamic> json) =>
    _$TodoModelImpl(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      done: json['done'] as bool,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TodoModelImplToJson(_$TodoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'done': instance.done,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
