import 'dart:async';

import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/storage/models/todo_cache_model.dart';
import 'package:fire_auth_server_client/storage/realm_provider.dart';
import 'package:fire_auth_server_client/utils/cache_model_common_mappers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<List<TodoModel>> toCommon() async {
    return state.map(todoCacheModelToCommon).toList();
  }

  Future<void> addManyWithCommon(List<TodoModel> models) async {
    final realm = ref.read(realmProvider);

    final toAddModels = models.map(commonToTodoCacheModel);
    final newTodos = List<TodoCacheModel>.empty(growable: true);

    realm.writeAsync(() {
      for (final model in toAddModels) {
        final exists = realm.find<TodoCacheModel>(model.id) != null;
        realm.add<TodoCacheModel>(model, update: exists);
        if (!exists) {
          newTodos.add(model);
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

  Future<void> updateWithCommon(TodoModel model) async {
    final updatedModel = commonToTodoCacheModel(model);
    final realm = ref.read(realmProvider);

    await realm.writeAsync(() {
      realm.add(updatedModel, update: true);
    });

    state = [
      for (final todo in state)
        if (todo.id != model.id) todo else updatedModel
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

  void restoreCache() {
    final realm = ref.read(realmProvider);

    realm.deleteAll<TodoCacheModel>();
    ref.invalidateSelf();
  }
}
