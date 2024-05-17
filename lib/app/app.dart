import 'package:fire_auth_server_client/app/pages/home_page.dart';
import 'package:fire_auth_server_client/app/pages/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Auth w/ client and custom server",
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
