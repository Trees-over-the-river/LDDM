import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pricely/database/itemdb.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widgets/item_widget.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key, required this.title, required this.listId})
      : super(key: key);

  final String title;
  final int listId;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> _items = [];
  List<Item> _checkedItems = [];

  final ItemDB _itemDB = ItemDB();

  @override
  void initState() {
    super.initState();
    _loadItemsFromDB();
  }

  @override
  void didUpdateWidget(covariant ItemListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o ID da lista mudar (ou seja, se a tela for exibida novamente com uma lista diferente), recarregue os itens.
    if (widget.listId != oldWidget.listId) {
      _loadItemsFromDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                onTap: () async {
                  await Navigator.of(context).pushNamed('/item',
                      arguments: [_items[index], false, widget.listId]);

                  // Recarrega a lista de itens após o fechamento do ItemDialog
                  _loadItemsFromDB();
                },
                onCheck: () {
                  setState(() {
                    var item = _items.removeAt(index);
                    item.isChecked = true;
                    _checkedItems.add(item);
                    _itemDB.update(item, widget.listId);
                  });
                },
                onDelete: () {
                  Item item = Item.empty();

                  setState(() {
                    item = _items.removeAt(index);
                    _itemDB.delete(item, widget.listId);
                  });

                  //Undo delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item removido'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            _itemDB.create(item, widget.listId);
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
              onReorder: (oldIndex, newIndex) {
                _reorderItems(false, oldIndex, newIndex);
              },
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
                onTap: () async {
                  await Navigator.of(context).pushNamed('/item',
                      arguments: [_checkedItems[index], false, widget.listId]);

                  // Recarrega a lista de itens após o fechamento do ItemDialog
                  _loadItemsFromDB();
                },
                onCheck: () {
                  setState(() {
                    var item = _checkedItems.removeAt(index);
                    item.isChecked = false;
                    _items.add(item);
                    _itemDB.update(item, widget.listId);
                  });
                },
                onDelete: () {
                  Item item = Item.empty();

                  setState(() {
                    item = _checkedItems.removeAt(index);
                    _itemDB.delete(item, widget.listId);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item removido'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            _itemDB.create(item, widget.listId);
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
              onReorder: (oldIndex, newIndex) {
                _reorderItems(true, oldIndex, newIndex);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/item',
              arguments: [Item.empty(), true, widget.listId]);

          // Recarrega a lista de itens após o fechamento do ItemDialog
          _loadItemsFromDB();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _loadItemsFromDB() async {
    final items = await _itemDB.fetchItems(widget.listId);
    setState(() {
      _items = items.where((element) => !element.isChecked).toList();
      _checkedItems = items.where((element) => element.isChecked).toList();
    });
  }

  void _reorderItems(bool isChecked, int oldIndex, int newIndex) async {
    setState(() {
      List<Item> itemList = isChecked ? _checkedItems : _items;

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Item item = itemList.removeAt(oldIndex);
      itemList.insert(newIndex, item);

      _itemDB.updateAll(itemList, widget.listId).then((_) {
        setState(() {
          if (isChecked) {
            _checkedItems = List.from(itemList);
          } else {
            _items = List.from(itemList);
          }
        });
      });
    });
  }
}
