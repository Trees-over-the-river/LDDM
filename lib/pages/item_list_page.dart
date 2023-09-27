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
  List<Item> items = [];

  List<Item> checkedItems = [];

  @override
  void initState() {
    super.initState();

    //TODO: Remove this, test only
    items = List.generate(
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
  }

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
      body: Column(
        children: [
          ReorderableListView.builder(
            cacheExtent: 200,
            onReorder: (oldIndex, newIndex) => setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            }),
            itemCount: items.length,
            itemBuilder: (context, index) => ItemWidget(
              items[index],
              key: ValueKey(items[index].id),
              onTap: () => Navigator.of(context)
                  .pushNamed('/item', arguments: items[index]),
              onCheck: () {
                setState(() {
                  items.removeAt(index);
                });
              },
              onDelete: () {
                setState(() {
                  items.removeAt(index);
                });
              },
            ),
          ),
          const Divider(
            thickness: 8,
          ),
          ReorderableListView.builder(
            cacheExtent: 200,
            itemBuilder: (context, index) => ItemWidget(
              checkedItems[index],
              key: ValueKey(checkedItems[index].id),
              onTap: () => Navigator.of(context)
                  .pushNamed('/item', arguments: checkedItems[index]),
              onCheck: () {
                setState(() {
                  items.removeAt(index);
                });
              },
              onDelete: () {
                setState(() {
                  items.removeAt(index);
                });
              },
            ),
            itemCount: checkedItems.length,
            onReorder: (oldIndex, newIndex) => setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = checkedItems.removeAt(oldIndex);
              checkedItems.insert(newIndex, item);
            }),
          ),
        ],
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
