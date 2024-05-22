import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  final bool done;
  final String description;
  final void Function(bool)? onDoneChange;
  final void Function(DismissDirection)? onDismissed;

  const TodoListTile({
    required this.done,
    required this.description,
    this.onDoneChange,
    this.onDismissed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          onChanged: (newValue) {
            if (newValue == null) {
              return;
            }

            onDoneChange?.call(newValue);
          },
        ),
        title: Text(description),
      ),
    );
  }
}
