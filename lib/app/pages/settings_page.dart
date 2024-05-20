import 'package:fire_auth_server_client/app/consumer_widgets/settings/settings_preferences.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: const SettingsPreferences()
    );
  }
}
