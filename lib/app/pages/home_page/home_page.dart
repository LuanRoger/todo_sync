import 'package:fire_auth_server_client/app/pages/home_page/add_todo_dialog.dart';
import 'package:fire_auth_server_client/app/widgets/list_tile/todo_list_tile.dart';
import 'package:fire_auth_server_client/providers/auth_provider.dart';
import 'package:fire_auth_server_client/services/todo_setvice/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final user = ref.read(authProvider);
    final todos = ref.watch(todoServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
        actions: [
          IconButton(
            icon: const Icon(Icons.key),
            onPressed: () async {
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
        ],
      ),
      body: todos.maybeWhen(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error),
                  Text("Não há itens"),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final currentTodo = data[index];
              return TodoListTile(
                done: currentTodo.done,
                description: currentTodo.description,
                onDoneChange: (newValue) {},
              );
            },
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final AddTodoDialog dialog = AddTodoDialog();
          final result = await dialog.show(context);
          if (result == null) {
            return;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
