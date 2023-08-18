import 'package:flutter/material.dart';

import '../model/item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  State<StatefulWidget> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Column(
        children: [
          Hero(
            tag: "Item image ${widget.item.id}",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Image(
                    image: widget.item.image ??
                        const AssetImage('assets/images/no_image.png'),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Text(widget.item.description ?? ''),
          Text(widget.item.category.join(' | ')),
          Text(widget.item.amount.toString()),
          Text(widget.item.amountUnit.name),
        ],
      ),
    );
  }
}
