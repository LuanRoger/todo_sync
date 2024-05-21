import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:fire_auth_server_client/storage/models/base/event.dart';
import 'package:fire_auth_server_client/storage/models/create_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/delete_todo_event.dart';
import 'package:fire_auth_server_client/storage/models/toggle_todo_event.dart';
import 'package:fire_auth_server_client/storage/realm_provider.dart';
import 'package:fire_auth_server_client/utils/action_model_todo_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offlineTodoEventSourcingProvider =
    NotifierProvider<OfflineTodoEventSourcingProvider, List<Event>>(
  OfflineTodoEventSourcingProvider.new,
);

class OfflineTodoEventSourcingProvider extends Notifier<List<Event>> {
  bool get isEmpty => state.isEmpty;

  @override
  List<Event> build() {
    final realm = ref.read(eventsRealmProvider);

    final creationEvents = realm.all<CreateTodoEvent>();
    final toggleEvents = realm.all<ToggleTodoEvent>();
    final deleteEvents = realm.all<DeleteTodoEvent>();

    final events = List<Event>.from(
      [
        ...creationEvents,
        ...toggleEvents,
        ...deleteEvents,
      ],
    );
    events.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return events;
  }

  Future<void> addCreateTodoActionWithCommon(CreateTodoRequest request) async {
    final realm = ref.read(eventsRealmProvider);
    final createEvent = createEventFromCreateRequest(request);

    await realm.writeAsync(() {
      realm.add<CreateTodoEvent>(createEvent);
    });

    state = [...state, createEvent];
  }

  Future<void> addToggleAction(int id) async {
    final realm = ref.read(eventsRealmProvider);
    final toggleAction = ToggleTodoEvent(id, DateTime.now().toUtc());

    await realm.writeAsync(() {
      realm.add<ToggleTodoEvent>(toggleAction);
    });

    state = [...state, toggleAction];
  }

  Future<void> hasBeenConsumed(Event event) async {
    final realm = ref.read(eventsRealmProvider);

    await realm.writeAsync(() {
      switch (event) {
        case CreateTodoEvent _:
          realm.delete<CreateTodoEvent>(event);
          break;
        case ToggleTodoEvent _:
          realm.delete<ToggleTodoEvent>(event);
          break;
        case DeleteTodoEvent _:
          realm.delete<DeleteTodoEvent>(event);
          break;
      }
    });
  }

  void project(List<TodoModel> models) {
    for (final event in state) {
      switch (event) {
        case CreateTodoEvent createEvent:
          models.add(createModelFromEvent(createEvent));
          break;
        case ToggleTodoEvent toggleEvent:
          TodoModel modifiedTodo =
              models.firstWhere((f) => toggleEvent.todoId == f.id);
          modifiedTodo = modifiedTodo.copyWith(done: !modifiedTodo.done);
          models = [
            for (final model in models)
              if (model.id == modifiedTodo.id) modifiedTodo else model
          ];
          break;
        case DeleteTodoEvent deleteEvent:
          models = [
            for (final model in models)
              if (model.id != deleteEvent.todoId) model
          ];
      }
    }
  }
}
