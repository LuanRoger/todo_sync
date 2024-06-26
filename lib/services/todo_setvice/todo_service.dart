import 'dart:async';

import 'package:fire_auth_server_client/exceptions/unexpected_response.dart';
import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/firebase_user_token.dart';
import 'package:fire_auth_server_client/providers/http_engine_provider.dart';
import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
import 'package:fire_auth_server_client/services/headers_consts.dart';
import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:fire_auth_server_client/storage/models/base/event.dart';
import 'package:fire_auth_server_client/storage/models/base/event_consumer.dart';
import 'package:fire_auth_server_client/storage/models/create_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/delete_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/toggle_todo_event.dart';
import 'package:fire_auth_server_client/utils/action_model_todo_mapper.dart';
import 'package:fire_auth_server_client/utils/json_extractor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final todoServiceProvider =
    AsyncNotifierProvider<TodoServiceNotifier, List<TodoModel>?>(
  TodoServiceNotifier.new,
);

class TodoServiceNotifier extends AsyncNotifier<List<TodoModel>?>
    implements EventConsumer {
  late String _userAuthToken;

  final String host = "192.168.0.10:7063";
  final String todoPath = "/todos";

  Map<String, String> get _defaultRequestHeader => {
        HeadersConsts.firebaseAuthHeader: _userAuthToken,
        "Content-Type": "application/json",
      };
  Uri get _todosRootEndpoint => Uri.http(host, todoPath);

  Uri _getUserTodosEndpoint({
    required int page,
    required int pageSize,
  }) {
    return Uri.http(host, todoPath, {
      "page": page.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  Uri _todoRouteEndpoint({required int id}) => Uri.http(host, "$todoPath/$id");

  @override
  FutureOr<List<TodoModel>?> build() async {
    final firebaseUserToken = await ref.watch(firebaseUserTokenProvider.future);
    final connection = await ref.watch(netConnectionProvider.future);

    if (firebaseUserToken == null) {
      return null;
    }
    _userAuthToken = firebaseUserToken;

    if (!connection.hasConnection) {
      return null;
    }

    List<TodoModel> todos;
    try {
      todos = await _getUserTodos();
    } on Exception {
      return null;
    }

    return todos;
  }

  Future<void> getUserTodos({
    int page = 1,
    int pageSize = 10,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _getUserTodos(page: page, pageSize: pageSize),
    );
  }

  Future<TodoModel?> createTodo(CreateTodoRequest request) async {
    final curentTodos = state.value;
    if (curentTodos == null) {
      return null;
    }

    TodoModel? newTodo;
    state = await AsyncValue.guard(() async {
      final createdTodo = await _createTodo(request);

      final newTodos = [...curentTodos, createdTodo];
      newTodo = createdTodo;
      return newTodos;
    });

    return newTodo;
  }

  Future<TodoModel?> toggleTodo(int id) async {
    final currentTodos = state.value;
    if (currentTodos == null) {
      return null;
    }

    TodoModel? modifiedTodo;
    state = await AsyncValue.guard(() async {
      final updatedTodo = await _toggleTodo(id);

      modifiedTodo = updatedTodo;
      return [
        for (final todo in currentTodos)
          if (todo.id == id) updatedTodo else todo
      ];
    });

    return modifiedTodo;
  }

  Future<int?> deleteTodo(int id) async {
    final currentTodos = state.value;
    if (currentTodos == null) {
      return null;
    }

    int? removedTodoId;
    state = await AsyncValue.guard(() async {
      final removedId = await _deleteTodo(id);

      removedTodoId = removedId;
      return [
        for (final transaction in currentTodos)
          if (transaction.id != removedId) transaction
      ];
    });

    return removedTodoId;
  }

  Future<TodoModel> _createTodo(CreateTodoRequest request) async {
    final http = ref.read(httpEngineProvider);

    final body = request.toJson();
    final rawBody = encodeDataToJson(body);

    final response = await http.post(
      _todosRootEndpoint,
      body: rawBody,
      headers: _defaultRequestHeader,
    );

    if (response.statusCode != 201) {
      throw UnexpectedResponse(response.statusCode);
    }

    final newTodoId = response.body;
    final infferedTodoId = int.parse(newTodoId);

    final newTodo = infferTodoModelByCreate(
      id: infferedTodoId,
      description: request.description,
      userId: _userAuthToken,
    );

    return newTodo;
  }

  Future<List<TodoModel>> _getUserTodos({
    int page = 1,
    int pageSize = 10,
  }) async {
    final http = ref.read(httpEngineProvider);
    final requestUri = _getUserTodosEndpoint(page: page, pageSize: pageSize);

    final response = await http.get(
      requestUri,
      headers: _defaultRequestHeader,
    );

    if (response.statusCode != 200) {
      throw UnexpectedResponse(response.statusCode);
    }

    final todos = _extractTodosFromResponse(response);
    return todos;
  }

  Future<TodoModel> _toggleTodo(int id) async {
    final http = ref.read(httpEngineProvider);
    final requestUri = _todoRouteEndpoint(id: id);

    final response = await http.post(
      requestUri,
      headers: _defaultRequestHeader,
    );

    if (response.statusCode != 200) {
      throw UnexpectedResponse(response.statusCode);
    }

    final json = getJsonFromResponseBody<Map<String, dynamic>>(response);
    final updatedTodo = TodoModel.fromJson(json);

    return updatedTodo;
  }

  Future<int> _deleteTodo(int id) async {
    final http = ref.read(httpEngineProvider);
    final requestUri = _todoRouteEndpoint(id: id);

    final response = await http.delete(
      requestUri,
      headers: _defaultRequestHeader,
    );

    if (response.statusCode != 200) {
      throw UnexpectedResponse(response.statusCode);
    }

    final newTodoId = response.body;
    final infferedTodoId = int.parse(newTodoId);

    return infferedTodoId;
  }

  List<TodoModel> _extractTodosFromResponse(Response response) {
    final jsonMap = getJsonFromResponseBody<List<dynamic>>(response);

    final todoList = jsonMap.map((todo) => TodoModel.fromJson(todo)).toList();
    return todoList;
  }

  @override
  Future<bool> consume(Event event) async {
    switch (event) {
      case CreateTodoEvent createEvent:
        final createRequest = createRequestFromEvent(createEvent);
        final result = await createTodo(createRequest);
        return result != null;
      case ToggleTodoEvent toggleEvent:
        final result = await toggleTodo(toggleEvent.todoId);
        return result != null;
      case DeleteTodoEvent deleteEvent:
        final result = await deleteTodo(deleteEvent.todoId);
        return result != null;
      default:
        return false;
    }
  }
}
