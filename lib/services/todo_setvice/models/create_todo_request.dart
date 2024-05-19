import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_todo_request.freezed.dart';
part 'create_todo_request.g.dart';

@freezed
class CreateTodoRequest with _$CreateTodoRequest {
  const factory CreateTodoRequest({
    required String description,
    required DateTime createdAt,
  }) = _CreateTodoRequest;

  factory CreateTodoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTodoRequestFromJson(json);
}
