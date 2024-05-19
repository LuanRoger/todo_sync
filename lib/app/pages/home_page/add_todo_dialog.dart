import 'package:fire_auth_server_client/services/todo_setvice/models/create_todo_request.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddTodoDialog {
  Future<CreateTodoRequest?> show(BuildContext context) {
    return showDialog<CreateTodoRequest?>(
      context: context,
      builder: (_) => const _AddTodoDialog(),
    );
  }
}

class _AddTodoDialog extends StatefulWidget {
  const _AddTodoDialog();

  @override
  State<_AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<_AddTodoDialog> {
  late final TextEditingController _controller;
  late bool isValid;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    isValid = true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nova terefa"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "Nome da tarefa",
          errorText: !isValid ? "Digite um valor válido" : null,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final isValid = _controller.text.isNotEmpty;
            setState(() {
              this.isValid = isValid;
            });
            if (!isValid) {
              return;
            }

            final createTodo = CreateTodoRequest(
              description: _controller.text,
              createdAt: DateTime.now(),
            );

            context.pop(createTodo);
          },
          child: const Text("Confirmar"),
        )
      ],
    );
  }
}
