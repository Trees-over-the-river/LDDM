import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widget/item_dialog.dart';
import 'package:pricely/widget/item_widget.dart';

import 'item_page.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key, this.items = const []}) : super(key: key);

  final List<Item> items;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> items = List.generate(
    1000,
    (index) => Item(index.toString(),
        name: 'Item $index',
        amount: Random().nextInt(1000),
        amountUnit: AmountUnit.none,
        image: CachedNetworkImageProvider(
          'https://picsum.photos/seed/$index/200/300',
          cacheKey: 'item_$index',
        ),
        category: List.generate(
          Random().nextInt(5),
          (index) => 'Category $index',
        ),
        description: 'Description $index'),
  );

  void _showDetails(Item item) {
    //Show a dialog with the item details
    showDialog(context: context, builder: (context) => ItemDialog(item: item));
  }

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
                  onTap: () => _showDetails(item),
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
