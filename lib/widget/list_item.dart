import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.title,
    this.description,
    this.onDelete,
  }) : super(key: key);

  final String title;
  final String? description;
  final void Function()? onDelete;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        color: _checked
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
            : null,
      ),
      child: Row(
        children: [
          Checkbox(
            value: _checked,
            onChanged: (value) {
              setState(() {
                _checked = value!;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: _checked ? FontStyle.italic : null,
                    decoration: _checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  widget.description ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    decoration: _checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: widget.onDelete, icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}
