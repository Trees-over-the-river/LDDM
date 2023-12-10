import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pricely/model/list.dart';
import 'package:pricely/pages/item_list_page.dart';

class ListGriditemWidget extends StatefulWidget {
  const ListGriditemWidget(this.itemList, {Key? key}) : super(key: key);

  final ItemList itemList;

  @override
  createState() => _ListGriditemWidgetState();
}

class _ListGriditemWidgetState extends State<ListGriditemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemListPage(
              title: widget.itemList.name, // Passando o título
              listId: widget.itemList.id, // Passando o ID da lista
            ),
          ),
        );
      },
      child: Card(
        color: Color(Random(widget.itemList.id).nextInt(0x666666) + 0xff999999),
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                widget.itemList.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.itemList.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
