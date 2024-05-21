import 'package:fire_auth_server_client/storage/models/create_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/delete_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/todo_cache_model.dart';
import 'package:fire_auth_server_client/storage/models/toggle_todo_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';

final realmProvider = Provider<Realm>((ref) {
  final realmConfig = Configuration.local([TodoCacheModel.schema]);
  final realm = Realm(realmConfig);

  ref.onDispose(() {
    realm.close();
  });

  return realm;
});

final eventsRealmProvider = Provider((ref) {
  final realmConfig = Configuration.local([
    CreateTodoEvent.schema,
    ToggleTodoEvent.schema,
    DeleteTodoEvent.schema,
  ]);
  final realm = Realm(realmConfig);

  ref.onDispose(() {
    realm.close();
  });

  return realm;
});
