import 'package:flutter/material.dart';

class Item {
  final String name;
  final String? description;
  final ImageProvider? image;
  final List<String> category;
  final String id;
  final int amount;
  final AmountUnit amountUnit;

  Item(
    this.id, {
    required this.name,
    this.description,
    this.image,
    this.category = const [],
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
  })  : assert(id.isNotEmpty),
        assert(name.isNotEmpty),
        assert(amount >= 0);

  Item.generateID({
    required this.name,
    this.description,
    this.image,
    this.category = const [],
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
  }) : id = UniqueKey().toString();

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      amount: json['amount'],
      amountUnit: AmountUnit.values[json['amountUnit']],
    );
  }
}

enum AmountUnit {
  kg,
  g,
  l,
  ml,
  none,
}

extension AmountUnitExtension on AmountUnit {
  String get name {
    switch (this) {
      case AmountUnit.kg:
        return 'kg';
      case AmountUnit.g:
        return 'g';
      case AmountUnit.l:
        return 'l';
      case AmountUnit.ml:
        return 'ml';
      case AmountUnit.none:
        return 'units';
    }
  }
}
