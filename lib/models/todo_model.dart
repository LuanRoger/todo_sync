import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required int id,
    required String description,
    required bool done,
    required String userId,
    required DateTime createdAt,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}
