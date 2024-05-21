import 'package:fire_auth_server_client/storage/models/base/event.dart';

abstract class EventConsumer {
  Future<bool> consume(Event event);
}