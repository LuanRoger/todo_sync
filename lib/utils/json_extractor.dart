import 'dart:convert';

import 'package:http/http.dart';

T getJsonFromResponseBody<T>(Response response) {
  final rawBody = response.body;
  return jsonDecode(rawBody);
}

String encodeDataToJson(Map<String, dynamic> data) {
  return jsonEncode(data);
}
