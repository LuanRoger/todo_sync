import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  final bool done;
  final String description;
  final void Function(bool)? onDoneChange;

  const TodoListTile({required this.done, required this.description, this.onDoneChange, super.key,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (newValue) {
          if(newValue == null) {
            return;
          }

          onDoneChange?.call(newValue);
        },
      ),
      title: Text(description),
    );
  }
}