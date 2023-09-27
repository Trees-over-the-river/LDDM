import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widgets/item_widget.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key, this.title = "Itens"}) : super(key: key);

  final String title;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final _items = <Item>[];
  final _checkedItems = <Item>[];

  @override
  void initState() {
    super.initState();

    //TODO: Remove this, test only
    _items.addAll(List.generate(
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
    ));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReorderableListView.builder(
              shrinkWrap: true,
              cacheExtent: 200,
              itemBuilder: (context, index) => ItemWidget(
                _items[index],
                key: ValueKey(_items[index].id),
                onTap: () => Navigator.of(context)
                    .pushNamed('/item', arguments: _items[index]),
                onCheck: () {
                  setState(() {
                    var item = _items.removeAt(index);
                    _checkedItems.add(item);
                  });
                },
                onDelete: () {
                  Item item = Item.empty();

                  setState(() {
                    item = _items.removeAt(index);
                  });

                  //Undo delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item removido'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            _items.insert(index, item);
                          });
                        },
                      ),
                    ),
                  );
                },
                checked: false,
              ),
              itemCount: _items.length,
              onReorder: (oldIndex, newIndex) => setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              }),
            ),
            const Divider(
              thickness: 8,
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              cacheExtent: 200,
              itemBuilder: (context, index) => ItemWidget(
                _checkedItems[index],
                key: ValueKey(_checkedItems[index].id),
                onTap: () => Navigator.of(context)
                    .pushNamed('/item', arguments: _checkedItems[index]),
                onCheck: () {
                  setState(() {
                    var item = _checkedItems.removeAt(index);
                    _items.add(item);
                  });
                },
                onDelete: () {
                  Item item = Item.empty();

                  setState(() {
                    item = _checkedItems.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item removido'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            _checkedItems.insert(index, item);
                          });
                        },
                      ),
                    ),
                  );
                },
                checked: true,
              ),
              itemCount: _checkedItems.length,
              onReorder: (oldIndex, newIndex) => setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _checkedItems.removeAt(oldIndex);
                _checkedItems.insert(newIndex, item);
              }),
            ),
          ],
        ),
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
