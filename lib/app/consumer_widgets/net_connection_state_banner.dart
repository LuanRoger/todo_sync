import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
import 'package:fire_auth_server_client/providers/todo_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetConnectionStateBanner extends ConsumerWidget {
  const NetConnectionStateBanner({super.key});

  final _noConnectionChildren = const [
    Icon(Icons.cloud_off),
    SizedBox(width: 10),
    Text("Sem conexão (offline)"),
  ];
  final _connectedChildren = const [
    Icon(Icons.cloud),
    SizedBox(width: 10),
    Text("Conectado (online)"),
  ];
  final _loadingChildren = const [
    Icon(Icons.cloud_download),
    SizedBox(width: 10),
    Text("Tentando connectar..."),
  ];
  final _errorChildren = const [
    Icon(Icons.clear),
    SizedBox(width: 10),
    Text("Error ao conectar..."),
  ];
  final _syncChildren = const [
    Icon(Icons.cloud_sync),
    SizedBox(width: 10),
    Text("Sincronizando..."),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primaryContainer;

    final connectionState = ref.watch(netConnectionProvider);
    // ignore: unused_local_variable
    final syncTrigger = ref.watch(todoSyncProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      color: primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: connectionState.when(
          data: (data) {
            final isSyncing = ref.watch(todoSyncProvider.notifier).isSyncing;
            if (isSyncing) {
              return _syncChildren;
            }

            return data.hasConnection
                ? _connectedChildren
                : _noConnectionChildren;
          },
          loading: () => _loadingChildren,
          error: (_, __) => _errorChildren,
        ),
      ),
    );
  }
}
