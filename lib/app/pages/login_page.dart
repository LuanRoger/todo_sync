import 'package:fire_auth_server_client/app/pages/home_page/home_page.dart';
import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isLoading = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formStateKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 10,
                  child: Text("Bem-vindo(a)", style: textTheme.headlineLarge),
                ),
                const Spacer(),
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Este campo é obrigatório";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "...@gmail.com",
                      labelText: "Email",
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 10,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Este campo é obrigatório";
                      }

                      if (value.length < 8) {
                        return "A senha deve ter ao menos 8 caracteres";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Senha",
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 10,
                  child: isLoading
                      ? const LinearProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final validationResult =
                                    _formStateKey.currentState?.validate() ??
                                        false;

                                if (!validationResult) {
                                  return;
                                }

                                setState(() => isLoading = true);

                                try {
                                  ref
                                      .read(authProvider.notifier)
                                      .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                } finally {
                                  setState(() => isLoading = false);
                                }

                                //Go to home page by GoRouter redirect
                              },
                              child: const Text("Entrar"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final validationResult =
                                    _formStateKey.currentState?.validate() ??
                                        false;

                                if (!validationResult) {
                                  return;
                                }

                                setState(() => isLoading = true);

                                try {
                                  ref
                                      .read(authProvider.notifier)
                                      .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                } finally {
                                  setState(() => isLoading = false);
                                }
                                //Go to home page by GoRouter redirect
                              },
                              child: const Text("Cadastrar"),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
