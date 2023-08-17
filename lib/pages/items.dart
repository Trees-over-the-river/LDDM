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
      image: Image.network('https://picsum.photos/200/300?random=$index',
          fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
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
      body: ReorderableListView(
          cacheExtent: 1000,
          onReorder: (oldIndex, newIndex) => setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
              }),
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
