import 'dart:async';

import 'package:fire_auth_server_client/exceptions/unexpected_response.dart';
import 'package:fire_auth_server_client/models/net_connection_state.dart';
import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/firebase_user_token.dart';
import 'package:fire_auth_server_client/providers/http_engine_provider.dart';
import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
import 'package:fire_auth_server_client/services/headers_consts.dart';
import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:fire_auth_server_client/storage/offline_todo_cache_provider.dart';
import 'package:fire_auth_server_client/utils/json_extractor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final todoServiceProvider =
    AsyncNotifierProvider<TodoServiceNotifier, List<TodoModel>>(
  TodoServiceNotifier.new,
);

class TodoServiceNotifier extends AsyncNotifier<List<TodoModel>> {
  late String _userAuthToken;
  late NetConnectionState _workingOnConnection;

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
  FutureOr<List<TodoModel>> build() async {
    final firebaseUserToken = ref.watch(firebaseUserTokenProvider);
    final connection = await ref.watch(netConnectionProvider.future);
    _workingOnConnection = connection;

    if (!firebaseUserToken.hasValue ||
        firebaseUserToken.isLoading ||
        firebaseUserToken.hasError) {
      return List.empty();
    }
    final token = firebaseUserToken.requireValue;
    if (token == null) {
      return List.empty();
    }
    _userAuthToken = token;

    List<TodoModel> todos;
    final offlineProvider = ref.read(offlineTodoCacheProvider.notifier);
    try {
      todos = connection.hasConnection
          ? await _getUserTodos()
          : await offlineProvider.toCommon();
    } on Exception {
      final cachedTodos = await offlineProvider.toCommon();
      todos = cachedTodos;
    }

    offlineProvider.addManyWithCommon(todos);

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

  Future<void> createTodo(CreateTodoRequest request) async {
    state = await AsyncValue.guard(() async {
      final newTodo = await _createTodo(request);

      final curentTodos = state.requireValue;
      final newTodos = [...curentTodos, newTodo];

      return newTodos;
    });
  }

  Future<void> toggleTodo(int id) async {
    state = await AsyncValue.guard(() async {
      final updatedTodo = await _toggleTodo(id);

      return [
        for (final todo in state.requireValue)
          if (todo.id == id) updatedTodo else todo
      ];
    });
  }

  Future<void> deleteTodo(int id) async {
    state = await AsyncValue.guard(() async {
      final removedId = await _deleteTodo(id);

      return [
        for (final transaction in state.requireValue)
          if (transaction.id != removedId) transaction
      ];
    });
  }

  void refresh() {
    if (!_workingOnConnection.hasConnection) {
      return;
    }

    final offlineCache = ref.read(offlineTodoCacheProvider.notifier);
    offlineCache.restoreCache();
    ref.invalidateSelf();
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

    final newTodo = TodoModel(
      id: infferedTodoId,
      description: request.description,
      done: false,
      userId: _userAuthToken,
      createdAt: DateTime.now(),
    );

    //TODO: Gravar a ação
    ref.read(offlineTodoCacheProvider.notifier).addWithCommon(newTodo);

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

    //TODO: Gravar a ação
    ref.read(offlineTodoCacheProvider.notifier).updateWithCommon(updatedTodo);

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

    //TODO: Gravar a ação
    ref.read(offlineTodoCacheProvider.notifier).deleteById(id);

    return infferedTodoId;
  }

  List<TodoModel> _extractTodosFromResponse(Response response) {
    final jsonMap = getJsonFromResponseBody<List<dynamic>>(response);

    final todoList = jsonMap.map((todo) => TodoModel.fromJson(todo)).toList();
    return todoList;
  }
}
