import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';

class ListGriditemWidget extends StatefulWidget {
  const ListGriditemWidget(this.items, {Key? key, this.title = ''})
      : super(key: key);

  final String title;
  final List<Item> items;

  @override
  _ListGriditemWidgetState createState() => _ListGriditemWidgetState();
}

class _ListGriditemWidgetState extends State<ListGriditemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
          ),
          //Image grid
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(4, (index) {
                  return (index < widget.items.length &&
                          widget.items[index].image != null)
                      ? Image(
                          image: widget.items[index].image!, fit: BoxFit.cover)
                      : const SizedBox.shrink();
                })),
          ),
          Text(
            'Itens: ${widget.items.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
