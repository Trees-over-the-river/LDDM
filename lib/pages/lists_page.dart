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
  createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<Widget> tiles = List.generate(
    10,
    (listi) => LimitedBox(
      maxHeight: 200,
      maxWidth: 200,
      child: ListGriditemWidget(
        List.generate(
          10,
          (index) => Item((index + listi * 10),
              name: 'Item ${index + listi * 10}',
              amount: Random().nextInt(1000),
              amountUnit: AmountUnit.none,
              image: CachedNetworkImageProvider(
                  'https://picsum.photos/seed/${index + listi * 100}/200/200',
                  cacheKey: 'item_${index + listi * 100}'),
              category: List.generate(
                Random().nextInt(5),
                (index) => 'Category $index',
              ),
              description: 'Description ${index + listi * 10}'),
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            icon: const Icon(Icons.question_mark),
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
      final item = tiles.removeAt(oldIndex);
      tiles.insert(newIndex, item);
    });
  }
}
