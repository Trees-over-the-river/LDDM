import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
    this.item, {
    required Key key,
    this.onDelete,
    this.onTap,
    this.checked = false,
    this.onCheck,
  }) : super(key: key);

  final Item item;
  final bool checked;
  final void Function()? onDelete; //Called when swiped left
  final void Function()? onCheck;
  final void Function()? onTap; //Called when clicked

  void _onDimissed(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      onDelete?.call();
    } else if (direction == DismissDirection.startToEnd) {
      onCheck?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      onDismissed: _onDimissed,
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
        onTap: onTap,
        title: Text(item.name,
            style: checked
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.bold)
                : const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.description ?? '',
            style: checked
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough, fontSize: 12)
                : const TextStyle(fontSize: 12)),
        trailing: Text('${item.amount} ${item.amountUnit.name}'),
        selected: checked,
        enableFeedback: true,
      ),
    );
  }
}
