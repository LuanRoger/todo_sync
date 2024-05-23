import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  final bool done;
  final String description;
  final bool isProjection;
  final void Function(bool)? onDoneChange;
  final void Function(DismissDirection)? onDismissed;

  const TodoListTile({
    required this.done,
    required this.description,
    this.onDoneChange,
    this.onDismissed,
    this.isProjection = false,
    super.key,
  });

  void _changeCheckboxValue(bool? newValue) {
    if (newValue == null) {
      return;
    }

    onDoneChange?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    if (isProjection) {
      return ListTile(
        leading: Checkbox(
          value: done,
          onChanged: null,
        ),
        title: Text(description),
        trailing: const Tooltip(
          message: "Bloqueado para edição enquanto não sincronizar.",
          child: Icon(Icons.sync_lock),
        ),
      );
    }

    return Dismissible(
      key: UniqueKey(),
      onDismissed: onDismissed,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Icon(Icons.delete),
      ),
      child: ListTile(
        leading: Checkbox(
          value: done,
          onChanged: _changeCheckboxValue,
        ),
        title: Text(description),
      ),
    );
  }
}
