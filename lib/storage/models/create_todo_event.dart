import 'package:fire_auth_server_client/storage/models/base/event.dart';
import 'package:realm/realm.dart';

part 'create_todo_event.realm.dart';

@RealmModel()
class _CreateTodoEvent implements Event {
  late String description;
  @override
  late DateTime createdAt;
}
