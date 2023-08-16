import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widget/item_widget.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<GlobalKey> keys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Items'),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            keys.add(GlobalKey());
            //Random item for testing
            return ItemWidget(
              key: keys[index],
              Item(
                name: 'Item $index',
                description: 'Description $index',
                image:
                    Image.network('https://unsplash.it/400/400?image=$index'),
                category: 'Category $index',
                id: 'id $index',
              ),
            );
          },
        ));
  }
}
