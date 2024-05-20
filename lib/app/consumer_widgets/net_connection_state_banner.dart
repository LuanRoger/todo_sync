import 'package:fire_auth_server_client/providers/net_connection_provider.dart';
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
    Icon(Icons.cloud_sync),
    SizedBox(width: 10),
    Text("Tentando connectar..."),
  ];
  final _errorChildren = const [
    Icon(Icons.clear),
    SizedBox(width: 10),
    Text("Error ao conectar..."),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primaryContainer;

    final connectionState = ref.watch(netConnectionProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      color: primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: connectionState.when(
          data: (data) =>
              data.hasConnection ? _connectedChildren : _noConnectionChildren,
          loading: () => _loadingChildren,
          error: (_, __) => _errorChildren,
        ),
      ),
    );
  }
}
