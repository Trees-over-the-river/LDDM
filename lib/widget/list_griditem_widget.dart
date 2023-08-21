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
    return Column(
      children: [
        ListView.builder(itemBuilder: (context, index) {
          return Hero(
              tag: 'Item image ${widget.items[index].id}',
              child: (widget.items[index].image == null)
                  ? Image(image: widget.items[index].image!)
                  : const SizedBox.shrink());
        })
      ],
    );
  }
}
