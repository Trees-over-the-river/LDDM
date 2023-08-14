import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    required Key key,
    required this.title,
    this.description,
    this.onDelete,
    this.onEdit,
    this.onCheck,
  }) : super(key: key);

  final String title;
  final String? description;
  final void Function()? onDelete; //Called when swiped left
  final void Function()? onEdit; //Called when clicked
  final void Function()?
      onCheck; //Called when checkbox is checked or swiped right

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            _checked = !_checked;
          });
          widget.onCheck?.call();
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete?.call();
        }
      },
      background: Container(
        color: Colors.green,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.check),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      child: ListTile(
        title: Text(widget.title),
        subtitle: widget.description != null ? Text(widget.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _checked,
              onChanged: (value) {
                setState(() {
                  _checked = value!;
                });
                widget.onCheck?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
