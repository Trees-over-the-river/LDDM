import 'package:flutter/material.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<int> items = List.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lists'),
      ),
      body: ReorderableGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Draggable(
            data: index,
            feedback: Container(
              key: ValueKey(items[index]),
              color: Colors.blueGrey.withOpacity(0.5),
              child: Center(
                child: Text(
                  items[index].toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            key: UniqueKey(),
            child: Container(
              key: ValueKey(items[index]),
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  items[index].toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
