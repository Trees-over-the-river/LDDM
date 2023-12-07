import 'dart:math';

class ItemList implements Comparable{
  String name;
  final int id;
  
  ItemList(
    this.id, {
    required this.name,
  })  :
        assert(name.isNotEmpty);

  ItemList.fromRow(Map<String, Object?> row) : id = row['ID'] as int, name = row['NAME'] as String;

  ItemList.generateID({
    required this.name,
  }) : id = Random().nextInt(1<<32);

  ItemList.empty({
    this.name = '',
  }) : id = Random().nextInt(1<<32);

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      json['id'],
      name: json['name'],
    );
  }

  @override
  int compareTo(covariant ItemList other) => id.compareTo(id);

  @override
  bool operator == (covariant ItemList other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ItemList, id = $id, name = $name';

}
