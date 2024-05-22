import 'dart:async';

import 'package:fire_auth_server_client/models/sync_state.dart';
import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
import 'package:fire_auth_server_client/providers/todo_provider.dart';
import 'package:fire_auth_server_client/services/todo_setvice/todo_service.dart';
import 'package:fire_auth_server_client/storage/offline_todo_cache_provider.dart';
import 'package:fire_auth_server_client/storage/offline_todo_event_sourcing_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoSyncProvider = AsyncNotifierProvider<TodoSyncProvider, SyncState>(
  TodoSyncProvider.new,
);

class TodoSyncProvider extends AsyncNotifier<SyncState> {
  @override
  FutureOr<SyncState> build() async {
    final connection = await ref.watch(netConnectionProvider.future);
    final eventSourcing = ref.watch(offlineTodoEventSourcingProvider);

    final tryToSync = connection.hasConnection && eventSourcing.isNotEmpty;

    if (tryToSync) {
      _trySyncEvents();
    }

    return tryToSync ? SyncState.late : SyncState.sync;
  }

  void _trySyncEvents() async {
    final offlineEventSourcing = ref.read(offlineTodoEventSourcingProvider);

    if (offlineEventSourcing.isEmpty) {
      return;
    }

    final todoService = ref.read(todoServiceProvider.notifier);

    bool hasCompletedSomeEvent = false;
    for (final event in offlineEventSourcing) {
      final completed = await todoService.consume(event);
      if (completed) {
        await ref
            .read(offlineTodoEventSourcingProvider.notifier)
            .hasBeenConsumed(event);
        hasCompletedSomeEvent = true;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    if (hasCompletedSomeEvent) {
      ref.invalidate(offlineTodoEventSourcingProvider);
      ref.invalidate(todoLocalCacheProvider);
      ref.invalidate(todoProvider);
      ref.invalidateSelf();
    }
  }
}
