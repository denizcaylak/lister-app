import 'package:flutter/material.dart';
import '../models/list_item.dart';

class ListTileItem extends StatelessWidget {
  final ListItem item;
  final VoidCallback onToggle;
  const ListTileItem({super.key, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              color: item.completed
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            child: item.completed
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          item.text,
          style: TextStyle(
            decoration: item.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
