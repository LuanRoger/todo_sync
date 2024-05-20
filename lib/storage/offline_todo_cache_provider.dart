import 'dart:async';

import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/storage/models/todo_cache_model.dart';
import 'package:fire_auth_server_client/storage/realm_provider.dart';
import 'package:fire_auth_server_client/utils/cache_model_common_mappers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoLocalCacheProvider = Provider<List<TodoModel>>((ref) {
  final offlineCache = ref.watch(offlineTodoCacheProvider);

  final commonModel = offlineCache.map(todoCacheModelToCommon).toList();

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
    final newTodos = List<TodoCacheModel>.empty(growable: true);

    await realm.writeAsync(() {
      for (final model in models) {
        final todo = commonToTodoCacheModel(model);
        final exists = realm.find<TodoCacheModel>(model.id) != null;

        realm.add<TodoCacheModel>(todo, update: exists);
        if (!exists) {
          newTodos.add(todo);
        }
      }
    });

    state = [...state, ...newTodos];
  }

  Future<void> addWithCommon(TodoModel model) async {
    final toAddModel = commonToTodoCacheModel(model);
    final realm = ref.read(realmProvider);

    await realm.writeAsync(() {
      realm.add<TodoCacheModel>(toAddModel);
    });

    state = [...state, toAddModel];
  }

  Future<void> toggleTodo(int id) async {
    final realm = ref.read(realmProvider);
    final toUpdateModel = realm.find<TodoCacheModel>(id);
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
    final todo = realm.find<TodoCacheModel>(id);
    if (todo == null) {
      return;
    }

    await realm.writeAsync(() {
      realm.delete<TodoCacheModel>(todo);
    });

    state = [
      for (final todo in state)
        if (todo.id != id) todo
    ];
  }

  Future<void> restoreCache() async {
    final realm = ref.read(realmProvider);

    await realm.writeAsync(() {
      realm.deleteAll<TodoCacheModel>();
    });
    state = List.empty();
  }
}
