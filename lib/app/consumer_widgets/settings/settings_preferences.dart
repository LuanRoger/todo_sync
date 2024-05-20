import 'package:fire_auth_server_client/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPreferences extends ConsumerWidget {
  const SettingsPreferences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return ListView(
      children: [
        ListTile(
          title: const Text("Verificar internet"),
          trailing: Switch(
            value: preferences.value?.checkNetConnection ?? false,
            onChanged: (newValue) => ref
                .read(preferencesProvider.notifier)
                .setCheckNetConnection(newValue),
          ),
        )
      ],
    );
  }
}
