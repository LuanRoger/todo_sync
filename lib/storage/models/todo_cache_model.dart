import 'package:realm/realm.dart';

part 'todo_cache_model.realm.dart';

@RealmModel()
class _TodoCacheModel {
  @PrimaryKey()
  late int cacheId;

  late int id;
  late String description;
  late bool done;
  late String userId;
  late DateTime createdAt;
}
