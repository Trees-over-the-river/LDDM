import 'dart:io';

class Item {
  final String name;
  final String description;
  final File image;
  final String category;
  final String id;
  final int amount;
  final AmountUnit amountUnit;

  Item({
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.id,
    this.amount = 0,
    this.amountUnit = AmountUnit.kg,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      id: json['id'],
      amount: json['amount'],
      amountUnit: json['amountUnit'],
    );
  }
}

enum AmountUnit {
  kg,
  g,
  l,
  ml,
  units,
}
