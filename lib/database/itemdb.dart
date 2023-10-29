import 'dart:async';

import 'package:pricely/model/item.dart';
import 'package:sqflite/sqflite.dart';

external String toString();

class ItemDB {
  static Database? _db;

  ItemDB();

  ItemDB.open(path) {
    open(path);
  }

  Future<void> open(String path) async {
    var databasesPath = await getDatabasesPath();
    print('Opening ItemDB at $databasesPath/$path');

    _db = await openDatabase('$databasesPath/$path',
        version: 1,
        onCreate: (db, version) => db.execute(
              '''CREATE TABLE IF NOT EXISTS ITEMS (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          NAME STRING NOT NULL,
          DESCRIPTION STRING,
          AMOUNT INTEGER NOT NULL,
          AMOUNT_UNIT INTEGER NOT NULL,
          ADDED_DATE DATETIME DEFAULT CURRENT_TIMESTAMP,
          IS_CHECKED INTEGER DEFAULT 0
        )''',
            ));

    print('ItemDB opened (db = $_db)');
  }

  Future<List<Item>> fetchItems() async {
    if (_db == null) {
      return [];
    }

    try {
      final read = await _db!.query('ITEMS',
          distinct: true,
          columns: [
            'ID',
            'NAME',
            'DESCRIPTION',
            'AMOUNT',
            'AMOUNT_UNIT',
            'IS_CHECKED',
          ],
          orderBy: 'ID');


      return read.map((row) {
        print(row);
        return Item.fromRow(row);
      }).toList();
    } catch (e) {
      print('Error fetching items = $e');
      return [];
    }
  }

  Future<bool> create(Item item) async {
    print('Creating Item (db = $_db)');

    final db = _db;
    if (db == null) {
      print('Database is null');
      return false;
    }

    try {
      await db.insert('ITEMS', {
        'ID': item.id,
        'NAME': item.name,
        'DESCRIPTION': item.description,
        'AMOUNT': item.amount,
        'AMOUNT_UNIT': item.amountUnit.index,
        'ADDED_DATE': item.addedDate,
        'IS_CHECKED': item.isChecked,
      });
      print('Item created');
    } catch (e) {
      print('Error in creating Item = $e');
      return false;
    }

    return true;
  }

  Future<bool> update(Item item) async {
    final db = _db;
    if(db == null) {
      return false;
    }

    try {
      db.update('ITEMS', {
        'NAME': item.name,
        'DESCRIPTION': item.description,
        'AMOUNT': item.amount,
        'AMOUNT_UNIT': item.amountUnit.index,
        'ADDED_DATE': item.addedDate,
        'IS_CHECKED': item.isChecked,
      },
      where: 'ID = ?',
      whereArgs: [item.id],
      ); 
      return true;
    } catch (e) {
      print('Failed to update item, error = $e');
      return false;
    }
  }

  Future<bool> delete(Item item) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      db.delete(
        'ITEMS',
        where: 'ID = ?',
        whereArgs: [item.id],
      );
      return true;
    } catch (e) {
      print('Deletion failed with error $e');
      return false;
    }
  }

  Future<bool> close() async {
    final db = _db;
    if (db == null) {
      return false;
    }

    await db.close();
    return true;
  }
}
