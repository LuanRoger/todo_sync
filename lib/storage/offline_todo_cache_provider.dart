import 'dart:async';

import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/uuid_generator_provider.dart';
import 'package:fire_auth_server_client/storage/models/todo_cache_model.dart';
import 'package:fire_auth_server_client/storage/offline_todo_event_sourcing_provider.dart';
import 'package:fire_auth_server_client/storage/realm_provider.dart';
import 'package:fire_auth_server_client/storage/realm_queries.dart';
import 'package:fire_auth_server_client/utils/cache_model_common_mappers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoLocalCacheProvider = Provider<List<TodoModel>>((ref) {
  final offlineCache = ref.watch(offlineTodoCacheProvider);
  final offlineEventSourcing = ref.watch(offlineTodoEventSourcingProvider);

  final commonModel = offlineCache.map(todoCacheModelToCommon).toList();
  ref.read(offlineTodoEventSourcingProvider.notifier).project(commonModel);

  return commonModel;
});

final offlineTodoCacheProvider =
    NotifierProvider<OfflineTodoCacheProvider, List<TodoCacheModel>>(
  OfflineTodoCacheProvider.new,
);

class OfflineTodoCacheProvider extends Notifier<List<TodoCacheModel>> {
  @override
  List<TodoCacheModel> build() {
    final realm = ref.read(realmProvider);
    final allTodos = realm.all<TodoCacheModel>();

    return allTodos.toList();
  }

  Future<void> addManyWithCommon(List<TodoModel> models) async {
    final realm = ref.read(realmProvider);
    final uuid = ref.read(uuidGeneratorProvier);
    final newTodos = List<TodoCacheModel>.empty(growable: true);

    await realm.writeAsync(() {
      for (final model in models) {
        final todo = commonToTodoCacheModel(model, cacheId: uuid.v1());
        final queryResult =
            realm.query<TodoCacheModel>(RealmQueries.whereIdEqual, [model.id]);
        final exists = queryResult.isNotEmpty;

        realm.add<TodoCacheModel>(todo, update: exists);
        if (!exists) {
          newTodos.add(todo);
        }
      }
    });

    state = [...state, ...newTodos];
  }

  Future<void> addWithCommon(TodoModel model) async {
    final realm = ref.read(realmProvider);
    final uuid = ref.read(uuidGeneratorProvier);
    final toAddModel = commonToTodoCacheModel(model, cacheId: uuid.v1());

    await realm.writeAsync(() {
      realm.add<TodoCacheModel>(toAddModel);
    });

    state = [...state, toAddModel];
  }

  Future<void> toggleTodo(int id) async {
    final realm = ref.read(realmProvider);
    final queryResult =
        realm.query<TodoCacheModel>(RealmQueries.whereIdEqual, [id]);
    final toUpdateModel = queryResult.isNotEmpty ? queryResult.first : null;
    if (toUpdateModel == null) {
      return;
    }

    await realm.writeAsync(() {
      toUpdateModel.done = !toUpdateModel.done;
    });

    state = [
      for (final todo in state)
        if (toUpdateModel.id == todo.id) toUpdateModel else todo
    ];
  }

  Future<void> deleteById(int id) async {
    final realm = ref.read(realmProvider);
    final queryResult =
        realm.query<TodoCacheModel>(RealmQueries.whereIdEqual, [id]);
    final todo = queryResult.isNotEmpty ? queryResult.first : null;
    if (todo == null) {
      return;
    }
    final deletedTodoId = todo.id;

    final newState = List<TodoCacheModel>.from([
      for (final todo in state)
        if (deletedTodoId != todo.id) todo
    ]);
    await realm.writeAsync(() {
      realm.delete<TodoCacheModel>(todo);
    });

    state = newState;
  }

  Future<void> restoreCache() async {
    final realm = ref.read(realmProvider);

    await realm.writeAsync(() {
      realm.deleteAll<TodoCacheModel>();
    });
    state = List.empty();
  }
}
