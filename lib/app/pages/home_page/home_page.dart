import 'package:fire_auth_server_client/app/consumer_widgets/net_connection_state_banner.dart';
import 'package:fire_auth_server_client/app/pages/home_page/add_todo_dialog.dart';
import 'package:fire_auth_server_client/app/router/pages_routes_name.dart';
import 'package:fire_auth_server_client/app/widgets/list_tile/todo_list_tile.dart';
import 'package:fire_auth_server_client/app/widgets/placeholders/no_items_placeholder.dart';
import 'package:fire_auth_server_client/models/todo_model.dart';
import 'package:fire_auth_server_client/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: NetConnectionStateBanner(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(PagesRoutesName.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: todos.maybeWhen(
        data: (data) => _HomePageBody(
          data: data,
          onRefresh: () => ref.read(todoProvider.notifier).refresh(),
          onDismissed: (_, todoId) async =>
              await ref.read(todoProvider.notifier).deleteTodo(todoId),
          onDoneChange: (_, todoId) async =>
              await ref.read(todoProvider.notifier).toggleTodo(todoId),
        ),
        error: (error, _) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ocorreu um error",
                  style: textTheme.titleLarge,
                ),
                Text(error.toString())
              ],
            ),
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

          ref.read(todoProvider.notifier).createTodo(result);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  final List<TodoModel> data;
  final Future<void> Function() onRefresh;
  final void Function(DismissDirection, int)? onDismissed;
  final void Function(bool, int)? onDoneChange;

  const _HomePageBody({
    required this.data,
    required this.onRefresh,
    this.onDismissed,
    this.onDoneChange,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const NoItemsPlaceholder();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final currentTodo = data[index];
          final todoId = currentTodo.id;
          final todoUserId = currentTodo.userId;
          final isProjection =
              todoId == 0 && todoUserId == "projection";

          return TodoListTile(
            done: currentTodo.done,
            description: currentTodo.description,
            isProjection: isProjection,
            onDoneChange: (value) => onDoneChange?.call(value, todoId),
            onDismissed: (value) => onDismissed?.call(value, todoId),
          );
        },
      ),
    );
  }
}
