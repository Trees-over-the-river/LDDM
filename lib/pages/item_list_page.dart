import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widgets/item_widget.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key, this.items = const [], this.title = "Itens"})
      : super(key: key);

  final String title;
  final List<Item> items;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> items = List.generate(
    10,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {
                FlutterContacts.openExternalPick();
              },
              icon: const Icon(Icons.share))
        ],
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
                onTap: () =>
                    Navigator.of(context).pushNamed('/item', arguments: item),
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
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/item', arguments: Item.empty());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
