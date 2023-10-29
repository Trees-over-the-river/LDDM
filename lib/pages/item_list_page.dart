import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pricely/database/itemdb.dart';
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

  final ItemDB _crudPricely = ItemDB();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) => _crudPricely.fetchItems().then((value) => setState(() {
              _items.clear();
              _checkedItems.clear();
              _items.addAll(value.where((element) => !element.isChecked));
              _checkedItems.addAll(value.where((element) => element.isChecked));
            })));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                    .pushNamed('/item', arguments: [_items[index], false]),
                onCheck: () {
                  setState(() {
                    var item = _items.removeAt(index);
                    item.isChecked = true;
                    _checkedItems.add(item);
                    ItemDB().update(item);
                  });
                },
                onDelete: () {
                  Item item = Item.empty();

                  setState(() {
                    item = _items.removeAt(index);
                    ItemDB().delete(item);
                  });

                  //Undo delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item removido'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            ItemDB().create(item);
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
                onTap: () => Navigator.of(context).pushNamed('/item',
                    arguments: [_checkedItems[index], false]),
                onCheck: () {
                  setState(() {
                    var item = _checkedItems.removeAt(index);
                    item.isChecked = false;
                    _items.add(item);
                    ItemDB().update(item);
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
                            ItemDB().create(item);
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
        onPressed: () async {
          Navigator.of(context)
              .pushNamed('/item', arguments: [Item.empty(), true]);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
