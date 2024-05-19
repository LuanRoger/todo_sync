// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_todo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTodoRequestImpl _$$CreateTodoRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTodoRequestImpl(
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CreateTodoRequestImplToJson(
        _$CreateTodoRequestImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
