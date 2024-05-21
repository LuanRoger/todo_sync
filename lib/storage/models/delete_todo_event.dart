import 'package:fire_auth_server_client/storage/models/base/event.dart';
import 'package:realm/realm.dart';

part 'delete_todo_event.realm.dart';

@RealmModel()
class _DeleteTodoEvent implements Event {
  late int todoId;
  @override
  late DateTime createdAt;
}
