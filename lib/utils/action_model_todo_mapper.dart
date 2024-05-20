import 'package:fire_auth_server_client/models/todo_model.dart';

TodoModel infferTodoModelByCreate({
  required int id,
  required String description,
  required String userId,
}) => TodoModel(
      id: id,
      description: description,
      done: false,
      userId: userId,
      createdAt: DateTime.now(),
    );