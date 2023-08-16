import 'package:flutter/material.dart';
import 'package:pricely/widget/item_widget.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Items'),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ItemWidget(
              key: ValueKey(index),
              title: 'Item $index',
              description: 'Description $index',
              onEdit: () {},
              onDelete: () {},
              onCheck: () {},
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
