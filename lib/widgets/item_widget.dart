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
    if (direction == DismissDirection.startToEnd) {
      // Swiped left
      onDelete?.call();
    } else if (direction == DismissDirection.endToStart) {
      // Swiped right
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
        leading: Hero(
          tag: "Item image ${item.id}",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Builder(
                builder: (context) {
                  if (item.image != null) {
                    return Image(
                      image: item.image!,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const Icon(Icons.image);
                  }
                },
              ),
            ),
          ),
        ),
        title: Text(item.name,
            style: checked
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null),
        subtitle: Text(item.description ?? '',
            style: checked
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null),
        trailing: Text('${item.amount} ${item.amountUnit.name}'),
        selected: checked,
        enableFeedback: true,
      ),
    );
  }
}
