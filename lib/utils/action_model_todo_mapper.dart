import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:fire_auth_server_client/storage/models/create_todo_event.dart';

TodoModel infferTodoModelByCreate({
  required int id,
  required String description,
  required String userId,
}) =>
    TodoModel(
      id: id,
      description: description,
      done: false,
      userId: userId,
      createdAt: DateTime.now(),
    );

CreateTodoEvent createEventFromCreateRequest(CreateTodoRequest request,
        {required String eventId}) =>
    CreateTodoEvent(
      eventId,
      request.description,
      request.createdAt.toUtc(),
    );

CreateTodoRequest createRequestFromEvent(CreateTodoEvent event) =>
    CreateTodoRequest(
      description: event.description,
      createdAt: event.createdAt,
    );

TodoModel createModelFromEvent(CreateTodoEvent event) => TodoModel(
      id: 0,
      description: event.description,
      done: false,
      userId: "projection",
      createdAt: event.createdAt,
    );
