import 'package:fire_auth_server_client/app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) {
                return;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (_) => false,
              );
            },
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

                print(token);
                return Text(!problem ? token : "Houve um error");
              },
            )
          ],
        ),
      ),
    );
  }
}
