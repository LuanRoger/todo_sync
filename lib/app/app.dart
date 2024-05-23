import 'package:fire_auth_server_client/app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "Todo Sync",
      theme: ThemeData(brightness: Brightness.dark),
      routerConfig: router,
    );
  }
}
