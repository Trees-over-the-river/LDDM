import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widgets/list_griditem_widget.dart';
import 'package:reorderables/reorderables.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<List<Item>> items = List.generate(
    10,
    (listi) => List.generate(
      100,
      (index) => Item((index + listi * 100).toString(),
          name: 'Item ${index + listi * 100}',
          amount: Random().nextInt(1000),
          amountUnit: AmountUnit.none,
          image: null,
          category: List.generate(
            Random().nextInt(5),
            (index) => 'Category $index',
          ),
          description: 'Description ${index + listi * 100}'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var tiles = [
      for (int i = 0; i < items.length; i++)
        SizedBox.square(
            dimension: MediaQuery.of(context).size.width / 2 - 30,
            child: ListGriditemWidget(items[i], title: 'List $i'))
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lists'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(8),
        child: ReorderableWrap(
          onReorder: _onReorder,
          maxMainAxisCount: 2,
          children: tiles,
        ),
      ),
    );
  }

  void _onReorder(oldIndex, newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }
}
