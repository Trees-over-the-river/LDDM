import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widget/item_widget.dart';

import 'item_page.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Item> items = List.generate(
    1000,
    (index) => Item(
      name: 'Item $index',
      description: 'Description $index',
      image: Image.network(
        'https://picsum.photos/200/300?random=$index',
        fit: BoxFit.cover,
      ),
      category: ['Category $index'],
      id: 'id $index',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Items'),
      ),
      body: ListView(
          cacheExtent: 300,
          children: items
              .map(
                (item) => ItemWidget(
                  item,
                  key: ValueKey(item.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemPage(item),
                      ),
                    );
                  },
                  onCheck: () {
                    setState(() {
                      items.remove(item);
                    });
                  },
                  onDelete: () {
                    setState(() {
                      items.remove(item);
                    });
                  },
                ),
              )
              .toList()),
    );
  }
}
