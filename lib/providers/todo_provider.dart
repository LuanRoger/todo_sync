import 'dart:async';

import 'package:fire_auth_server_client/models/net_connection_state.dart';
import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:fire_auth_server_client/services/todo_setvice/todo_service.dart';
import 'package:fire_auth_server_client/storage/offline_todo_cache_provider.dart';
import 'package:fire_auth_server_client/utils/action_model_todo_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoProvider = AsyncNotifierProvider<TodoProvider, List<TodoModel>>(
  TodoProvider.new,
);

class TodoProvider extends AsyncNotifier<List<TodoModel>> {
  late NetConnectionState _workingOnConnection;
  bool get hasConnection => _workingOnConnection.hasConnection;

  @override
  FutureOr<List<TodoModel>> build() async {
    final connection = await ref.watch(netConnectionProvider.future);
    final todoService = await ref.read(todoServiceProvider.future);
    final offlineTodoCache = ref.read(todoLocalCacheProvider);
    _workingOnConnection = connection;

    return _workingOnConnection.hasConnection && todoService != null
        ? todoService
        : offlineTodoCache;
  }

  Future<void> createTodo(CreateTodoRequest request) async {
    final service = ref.read(todoServiceProvider.notifier);
    final offlineCache = ref.read(offlineTodoCacheProvider.notifier);

    final createdTodo = await service.createTodo(request);
    if (createdTodo == null) {
      final ghostTodo = infferTodoModelByCreate(
        id: 0,
        description: request.description,
        userId: "cache",
      );
      await offlineCache.addWithCommon(ghostTodo);
      //TODO: Add action to event sourcing
    } else {
      offlineCache.addWithCommon(createdTodo);
    }

    ref.invalidateSelf();
  }

  Future<void> toggleTodo(int id) async {
    final service = ref.read(todoServiceProvider.notifier);
    final offlineCache = ref.read(offlineTodoCacheProvider.notifier);

    final toggledTodo = await service.toggleTodo(id);
    await offlineCache.toggleTodo(id);
    if (toggledTodo == null) {
      //TODO: Add action to event sourcing
    }

    ref.invalidateSelf();
  }

  Future<void> deleteTodo(int id) async {
    final service = ref.read(todoServiceProvider.notifier);
    final offlineCache = ref.read(offlineTodoCacheProvider.notifier);

    final deletedTodo = await service.deleteTodo(id);
    await offlineCache.deleteById(id);
    if (deletedTodo == null) {
      //TODO: Add action to event sourcing
    }

    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    if (!_workingOnConnection.hasConnection) {
      return;
    }

    final offlineCache = ref.read(offlineTodoCacheProvider.notifier);
    final restoration = await Future.wait<dynamic>([
      offlineCache.restoreCache(),
      ref.watch(todoServiceProvider.future),
    ]);
    final onlineServiceTodos = restoration[1] as List<TodoModel>;
    offlineCache.addManyWithCommon(onlineServiceTodos);

    ref.invalidate(todoServiceProvider);
    ref.invalidateSelf();
  }
}
