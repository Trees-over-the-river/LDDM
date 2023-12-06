import 'dart:math';

import 'package:flutter/material.dart';

class Item implements Comparable{
  String name;
  String? description;
  ImageProvider? image; // TODO: colocar imagem?
  final int id;
  int amount;
  DateTime? addedDate;
  late AmountUnit amountUnit;  
  bool isChecked;

  Item(
    this.id, {
    required this.name,
    this.description,
    this.image,
    this.addedDate,
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
    this.isChecked = false,
  })  :
        assert(name.isNotEmpty),
        assert(amount >= 0) {
    addedDate ??= DateTime.now();
  }

  Item.fromRow(Map<String, Object?> row) : id = row['ID'] as int, name = row['NAME'] as String, description = row['DESCRIPTION'] as String?, amount = row['AMOUNT'] as int, amountUnit = AmountUnit.values[row['AMOUNT_UNIT'] as int], isChecked = row['IS_CHECKED'] as int == 1;

  Item.generateID({
    required this.name,
    this.isChecked = false,
    this.description,
    this.image,
    this.addedDate,
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
  }) : id = Random().nextInt(1<<32);


  Item.empty({
    this.name = '',
    this.isChecked = false,
    this.description,
    this.image,
    this.addedDate,
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
  }) : id = Random().nextInt(1<<32);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      amount: json['amount'],
      amountUnit: AmountUnit.values[json['amountUnit']],
    );
  }

  @override
  int compareTo(covariant Item other) => id.compareTo(id);

  @override
  bool operator == (covariant Item other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Item, id = $id, name = $name, description = $description, amount = $amount';

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
