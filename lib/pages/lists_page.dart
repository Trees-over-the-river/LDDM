import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widgets/create_lists_dialog.dart';
import 'package:pricely/widgets/list_griditem_widget.dart';
import 'package:reorderables/reorderables.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<Widget> tiles = List.generate(
    10,
    (listi) => SizedBox(
      width: 200,
      height: 200,
      child: ListGriditemWidget(
        List.generate(
          100,
          (index) => Item((index + listi * 100).toString(),
              name: 'Item ${index + listi * 100}',
              amount: Random().nextInt(1000),
              amountUnit: AmountUnit.none,
              image: CachedNetworkImageProvider(
                  'https://picsum.photos/seed/${index + listi * 100}/200/200',
                  cacheKey: 'item_${index + listi * 100}'),
              category: List.generate(
                Random().nextInt(5),
                (index) => 'Category $index',
              ),
              description: 'Description ${index + listi * 100}'),
        ),
        title: "List $listi",
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Listas'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(8),
        child: ReorderableWrap(
          onReorder: _onReorder,
          children: tiles,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => const CreateListsDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onReorder(oldIndex, newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = tiles.removeAt(oldIndex);
      tiles.insert(newIndex, item);
    });
  }
}
