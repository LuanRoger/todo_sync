import 'package:fire_auth_server_client/storage/models/base/event.dart';
import 'package:realm/realm.dart';

part "toggle_todo_event.realm.dart";

@RealmModel()
class _ToggleTodoEvent implements Event {
  @PrimaryKey()
  @override
  late String eventId;

  late int todoId;
  @override
  late DateTime createdAt;
}
