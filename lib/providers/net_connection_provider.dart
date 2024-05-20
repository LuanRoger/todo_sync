import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fire_auth_server_client/models/net_connection_state.dart';
import 'package:fire_auth_server_client/providers/preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final netConnectionProvider =
    AsyncNotifierProvider<NetConnectionProvider, NetConnectionState>(
  NetConnectionProvider.new,
);

class NetConnectionProvider extends AsyncNotifier<NetConnectionState> {
  late Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectionListener;
  late bool _listenToConnectionChanges;

  @override
  FutureOr<NetConnectionState> build() async {
    _connectivity = Connectivity();
    final checkNetConnection = ref.watch(
      preferencesProvider.select(
        (f) =>
            f.whenOrNull(
              data: (data) => data.checkNetConnection,
            ) ??
            true,
      ),
    );

    if (!checkNetConnection) {
      _connectionListener?.cancel();
      _connectionListener = null;
      return const NetConnectionState();
    }

    _connectionListener ??=
        _connectivity.onConnectivityChanged.listen(_onConnectivityChange);
    ref.onDispose(() async {
      await _connectionListener?.cancel();
    });
    _listenToConnectionChanges = true;

    final initialCheck = await _connectivity.checkConnectivity();
    return _mountNetState(initialCheck);
  }

  void pauseListen() {
    if (_connectionListener == null || !_listenToConnectionChanges) {
      return;
    }

    _connectionListener!.pause();
    state = const AsyncValue.data(NetConnectionState());
  }

  Future<void> resumeListen() async {
    if (_connectionListener == null || _listenToConnectionChanges) {
      return;
    }

    _connectionListener?.resume();
    final initialCheck = await _connectivity.checkConnectivity();
    state = AsyncValue.data(_mountNetState(initialCheck));
  }

  void _onConnectivityChange(List<ConnectivityResult> results) {
    if (results.length == 1 && results.first == ConnectivityResult.none) {
      state = const AsyncValue.data(NetConnectionState());
    }

    state = AsyncValue.data(_mountNetState(results));
  }

  NetConnectionState _mountNetState(List<ConnectivityResult> results) {
    final hasWifi = results.contains(ConnectivityResult.wifi);
    final hasMobileData = results.contains(ConnectivityResult.mobile);

    return NetConnectionState(wifi: hasWifi, mobileData: hasMobileData);
  }
}
