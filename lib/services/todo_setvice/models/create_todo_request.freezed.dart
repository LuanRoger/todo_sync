// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_todo_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateTodoRequest _$CreateTodoRequestFromJson(Map<String, dynamic> json) {
  return _CreateTodoRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTodoRequest {
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateTodoRequestCopyWith<CreateTodoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTodoRequestCopyWith<$Res> {
  factory $CreateTodoRequestCopyWith(
          CreateTodoRequest value, $Res Function(CreateTodoRequest) then) =
      _$CreateTodoRequestCopyWithImpl<$Res, CreateTodoRequest>;
  @useResult
  $Res call({String description, DateTime createdAt});
}

/// @nodoc
class _$CreateTodoRequestCopyWithImpl<$Res, $Val extends CreateTodoRequest>
    implements $CreateTodoRequestCopyWith<$Res> {
  _$CreateTodoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateTodoRequestImplCopyWith<$Res>
    implements $CreateTodoRequestCopyWith<$Res> {
  factory _$$CreateTodoRequestImplCopyWith(_$CreateTodoRequestImpl value,
          $Res Function(_$CreateTodoRequestImpl) then) =
      __$$CreateTodoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, DateTime createdAt});
}

/// @nodoc
class __$$CreateTodoRequestImplCopyWithImpl<$Res>
    extends _$CreateTodoRequestCopyWithImpl<$Res, _$CreateTodoRequestImpl>
    implements _$$CreateTodoRequestImplCopyWith<$Res> {
  __$$CreateTodoRequestImplCopyWithImpl(_$CreateTodoRequestImpl _value,
      $Res Function(_$CreateTodoRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_$CreateTodoRequestImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTodoRequestImpl implements _CreateTodoRequest {
  const _$CreateTodoRequestImpl(
      {required this.description, required this.createdAt});

  factory _$CreateTodoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTodoRequestImplFromJson(json);

  @override
  final String description;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CreateTodoRequest(description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTodoRequestImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTodoRequestImplCopyWith<_$CreateTodoRequestImpl> get copyWith =>
      __$$CreateTodoRequestImplCopyWithImpl<_$CreateTodoRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTodoRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateTodoRequest implements CreateTodoRequest {
  const factory _CreateTodoRequest(
      {required final String description,
      required final DateTime createdAt}) = _$CreateTodoRequestImpl;

  factory _CreateTodoRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTodoRequestImpl.fromJson;

  @override
  String get description;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CreateTodoRequestImplCopyWith<_$CreateTodoRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
