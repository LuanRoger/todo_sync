import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/storage/models/todo_cache_model.dart';

TodoModel todoCacheModelToCommon(TodoCacheModel model) => TodoModel(
      id: model.id,
      description: model.description,
      done: model.done,
      userId: model.userId,
      createdAt: model.createdAt.toUtc(),
    );

TodoCacheModel commonToTodoCacheModel(TodoModel model,
        {required String cacheId}) =>
    TodoCacheModel(
      cacheId,
      model.id,
      model.description,
      model.done,
      model.userId,
      model.createdAt.toUtc(),
    );
