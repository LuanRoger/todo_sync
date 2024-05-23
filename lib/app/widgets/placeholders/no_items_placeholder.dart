import 'package:flutter/material.dart';

class NoItemsPlaceholder extends StatelessWidget {
  const NoItemsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 50),
          Text(
            "Não há itens.",
            style: textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
