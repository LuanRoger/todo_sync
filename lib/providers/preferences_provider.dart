import 'dart:async';

import 'package:fire_auth_server_client/models/preferences_model.dart';
import 'package:fire_auth_server_client/providers/cosnts/preferences_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider =
    AsyncNotifierProvider<PreferencesProvider, PreferencesModel>(
  PreferencesProvider.new,
);

class PreferencesProvider extends AsyncNotifier<PreferencesModel> {
  late final SharedPreferences _sharedPreferences;

  @override
  FutureOr<PreferencesModel> build() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    return _createModel();
  }

  void setCheckNetConnection(bool newValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _sharedPreferences.setBool(
          PreferencesKey.checkNetConnection, newValue);

      return state.requireValue.copyWith(checkNetConnection: newValue);
    });
  }

  Future<PreferencesModel> _createModel() async {
    final checkNetConnectionKeyExists = _sharedPreferences.containsKey(
      PreferencesKey.checkNetConnection,
    );

    if (!checkNetConnectionKeyExists) {
      await _sharedPreferences.setBool(PreferencesKey.checkNetConnection, true);
    }

    final checkNetConnection = _sharedPreferences.getBool(
      PreferencesKey.checkNetConnection,
    )!;

    return PreferencesModel(checkNetConnection: checkNetConnection);
  }
}
