import 'dart:math';

import 'package:pricely/model/item.dart';
import 'package:flutter/material.dart';

class ItemList implements Comparable{
  String name;
  List<Item>? items;
  final int id;
  
  ItemList(
    this.id, {
    required this.name,
    this.items,
  })  :
        assert(name.isNotEmpty);

  ItemList.fromRow(Map<String, Object?> row) : id = row['ID'] as int, name = row['NAME'] as String, items = row['ITEMS'] as List<Item>;

  ItemList.generateID({
    required this.name,
    this.items,
  }) : id = Random().nextInt(1<<32);

  ItemList.empty({
    this.name = '',
    this.items,
  }) : id = Random().nextInt(1<<32);

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      json['id'],
      name: json['name'],
      items: json['items'],
    );
  }

  @override
  int compareTo(covariant ItemList other) => id.compareTo(id);

  @override
  bool operator == (covariant ItemList other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ItemList, id = $id, name = $name, items = $items';

}
