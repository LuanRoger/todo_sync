import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseUserTokenProvider = FutureProvider<String?>((ref) {
  final user = ref.watch(authProvider);

  return user?.getIdToken();
});
