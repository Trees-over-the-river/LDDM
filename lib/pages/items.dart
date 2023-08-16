import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';
import 'package:pricely/widget/item_widget.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Key> keys = List.generate(1000, (index) => UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Items'),
        ),
        body: ListView.builder(
          itemCount: 1000,
          itemBuilder: (context, index) {
            //Random item for testing
            return ItemWidget(
              key: keys[index],
              Item(
                name: 'Item $index',
                description: 'Description $index',
                image: Image.network(
                  'https://unsplash.it/400/400?image=${Random().nextInt(1000)}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
                category: 'Category $index',
                id: 'id $index',
              ),
            );
          },
          cacheExtent: 100,
        ));
  }
}
