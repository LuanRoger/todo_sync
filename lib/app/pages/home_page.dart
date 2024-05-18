import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
        actions: [
          IconButton(
            onPressed: () async => await ref.read(authProvider.notifier).signOut(),
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user.displayName ?? "Desconhecido",
              style: textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(user.email ?? ""),
            FutureBuilder(
              future: user.getIdToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final problem = snapshot.hasError || !snapshot.hasData;
                final token = snapshot.data!;

                return Text(!problem ? token : "Houve um error");
              },
            )
          ],
        ),
      ),
    );
  }
}
