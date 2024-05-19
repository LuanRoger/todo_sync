import 'package:fire_auth_server_client/app/pages/home_page/home_page.dart';
import 'package:fire_auth_server_client/app/pages/login_page.dart';
import 'package:fire_auth_server_client/app/router/pages_routes.dart';
import 'package:fire_auth_server_client/app/router/pages_routes_name.dart';
import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _routerKey = GlobalKey<NavigatorState>();

final routerProvider = Provider(
  (ref) {
    final auth = ref.watch(authProvider);

    return GoRouter(
      navigatorKey: _routerKey,
      initialLocation: PagesRoutes.home,
      routes: [
        GoRoute(
          path: PagesRoutes.login,
          name: PagesRoutesName.login,
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: PagesRoutes.home,
          name: PagesRoutesName.home,
          builder: (_, __) => const HomePage(),
        )
      ],
      redirect: (context, state) {
        if (auth == null) {
          return PagesRoutes.login;
        }

        return null;
      },
    );
  },
);
