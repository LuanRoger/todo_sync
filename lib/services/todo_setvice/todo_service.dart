import 'dart:async';

import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/firebase_user_token.dart';
import 'package:fire_auth_server_client/providers/http_engine_provider.dart';
import 'package:fire_auth_server_client/services/headers_consts.dart';
import 'package:fire_auth_server_client/utils/json_extractor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final todoServiceProvider =
    AsyncNotifierProvider<TodoServiceNotifier, List<TodoModel>>(
  TodoServiceNotifier.new,
);

class TodoServiceNotifier extends AsyncNotifier<List<TodoModel>> {
  final String baseUrl = "http://192.168.0.10:7063/todos?page=1&pageSize=10";
  Uri get baseUri => Uri.parse(baseUrl);

  @override
  FutureOr<List<TodoModel>> build() async {
    final http = ref.read(httpEngineProvider);
    final firebaseUserToken = ref.watch(firebaseUserTokenProvider);
    if (!firebaseUserToken.hasValue ||
        firebaseUserToken.isLoading ||
        firebaseUserToken.hasError) {
      return List.empty();
    }
    final token = firebaseUserToken.requireValue;
    if (token == null) {
      return List.empty();
    }

    final response = await http.get(baseUri, headers: {
      HeadersConsts.firebaseAuthHeader: token,
    });
    if (response.statusCode != 200) {
      return List.empty();
    }
    final todos = _extractTodosFromResponse(response);

    return todos;
  }

  List<TodoModel> _extractTodosFromResponse(Response response) {
    final jsonMap =
        getJsonFromResponseBody<List<dynamic>>(response);

    final todoList = jsonMap.map((todo) => TodoModel.fromJson(todo)).toList();
    return todoList;
  }
}
