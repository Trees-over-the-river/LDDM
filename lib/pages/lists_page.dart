import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pricely/database/itemdb.dart';
import 'package:pricely/database/listdb.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/model/list.dart';
import 'package:pricely/widgets/list_griditem_widget.dart';
import 'package:reorderables/reorderables.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final ListDB _listDB = ListDB();
  final ItemDB _itemDB = ItemDB();

  late final Timer _timer;
  List<ItemList> _lists = [];

  ItemList? _lastRemoved;
  int? _lastRemovedIndex;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _listDB.fetchItemLists().then((value) => setState(() {
            _lists = value;
          })),
    );
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
        title: const Text('Minhas Listas'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            icon: const Icon(Icons.info),
            color: Colors.black,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(8),
        child: ReorderableWrap(
          runSpacing: 8,
          onReorder: _onReorder,
          enableReorder: false,
          children: _lists.asMap().entries.map<Widget>((entry) {
            final int index = entry.key;
            final ItemList list = entry.value;

            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                _removeList(list, index);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.black),
              ),
              child: LimitedBox(
                maxHeight: 200,
                maxWidth: 200,
                child: FutureBuilder<List<Item>>(
                  future: _itemDB.fetchItems(list.id), // Busca os itens correspondentes à lista
                  builder: (context, snapshot) {
                    return ListGriditemWidget(
                      const [],
                      title: list.name,
                      listId: list.id,
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed('/list', arguments: [ItemList.empty()]);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onReorder(oldIndex, newIndex) {
    setState(() {
      final ItemList list = _lists.removeAt(oldIndex);
      _lists.insert(newIndex, list);
    });
  }

  Future<void> _removeList(ItemList list, int index) async {
    // Armazena temporariamente a lista removida para desfazer
    setState(() {
      _lastRemoved = list;
      _lastRemovedIndex = index;
      _lists.removeAt(index);
      _listDB.delete(list);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lista removida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            _undoRemove();
          },
        ),
      ),
    );

    await _listDB.delete(list);
  }

  void _undoRemove() {
    // Restaura a lista removida
    setState(() {
      if (_lastRemoved != null && _lastRemovedIndex != null) {
        _lists.insert(_lastRemovedIndex!, _lastRemoved!);
        _listDB.create(_lastRemoved!);
        _lastRemoved = null;
        _lastRemovedIndex = null;
      }
    });
  }
}
