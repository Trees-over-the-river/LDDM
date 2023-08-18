import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget(
    this.item, {
    required Key key,
    this.onDelete,
    this.onTap,
    this.onCheck,
  }) : super(key: key);

  final Item item;
  final void Function()? onDelete; //Called when swiped left
  final void Function()? onTap; //Called when clicked
  final void Function()? onCheck; //Called when swiped right

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _checked = false;

  void _onDimissed(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      setState(() {
        _checked = !_checked;
      });
      widget.onCheck?.call();
    } else if (direction == DismissDirection.endToStart) {
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
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
        onTap: widget.onTap,
        leading: Hero(
          tag: "Item image ${widget.item.id}",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Builder(
                builder: (context) {
                  if (widget.item.image != null) {
                    return Image(
                      image: widget.item.image!,
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
        title: Text(widget.item.name),
        subtitle: Text(widget.item.description ?? ''),
        trailing: Text('${widget.item.amount} ${widget.item.amountUnit.name}'),
        selected: _checked,
        enableFeedback: true,
      ),
    );
  }
}
