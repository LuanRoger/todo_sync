import 'package:fire_auth_server_client/app/consumer_widgets/settings/settings_preferences.dart';
import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações"), actions: [
        IconButton(
          icon: const Icon(Icons.key),
          onPressed: () async {
            final user = ref.read(authProvider);
            final token = await user?.getIdToken();
            if (token == null) {
              return;
            }

            final data = ClipboardData(text: token);
            Clipboard.setData(data);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Token do usuário copiado para a área de transferencia",
                  ),
                ),
              );
            }
          },
        ),
        IconButton(
          onPressed: () async =>
              await ref.read(authProvider.notifier).signOut(),
          icon: const Icon(Icons.exit_to_app),
        ),
      ]),
      body: const SettingsPreferences(),
    );
  }
}
