import 'package:cronet_http/cronet_http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final httpEngineProvider = Provider<Client>((ref) {
  final Client client = CronetClient.defaultCronetEngine();

  return client;
});
