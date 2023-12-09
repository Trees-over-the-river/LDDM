import 'dart:async';

import 'package:pricely/model/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemDB {
  static late Database _db;

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
                    LIST_ID INTEGER NOT NULL, 
                    NAME STRING NOT NULL,
                    DESCRIPTION STRING,
                    AMOUNT INTEGER NOT NULL,
                    AMOUNT_UNIT INTEGER NOT NULL,
                    ADDED_DATE DATETIME DEFAULT CURRENT_TIMESTAMP,
                    IS_CHECKED INTEGER DEFAULT 0,
                    FOREIGN KEY (LIST_ID) REFERENCES LISTS (ID)
                     ON DELETE NO ACTION ON UPDATE NO ACTION
                  )''',
            ));

    print('ItemDB opened (db = $_db)');
  }
  
  Future<List<Item>> fetchItems(int listId) async {
    try {
      final read = await _db.query('ITEMS', 
          where: 'LIST_ID = ?', 
          whereArgs: [listId],
          distinct: true,
          columns: [
            'ID',
            'LIST_ID',
            'NAME',
            'DESCRIPTION',
            'AMOUNT',
            'AMOUNT_UNIT',
            'IS_CHECKED',
          ]);


      return read.map((row) {
        print(row);
        return Item.fromRow(row);
      }).toList();
    } catch (e) {
      print('Error fetching items = $e');
      return [];
    }
  }

  Future<bool> create(Item item, int listId) async {
    print('Creating Item (db = $_db)');
    
    final db = _db;
   
    try {
      await db.insert('ITEMS', {
        'ID': item.id,
        'LIST_ID': listId,
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

  Future<bool> update(Item item, int listId) async {
    final db = _db;
    
    try {
      db.update('ITEMS', {
        'NAME': item.name,
        'DESCRIPTION': item.description,
        'AMOUNT': item.amount,
        'AMOUNT_UNIT': item.amountUnit.index,
        'ADDED_DATE': item.addedDate,
        'IS_CHECKED': item.isChecked,
      },
      where: 'LIST_ID = ? AND ID = ?',
      whereArgs: [listId, item.id],
      ); 
      return true;
    } catch (e) {
      print('Failed to update item, error = $e');
      return false;
    }
  }

  Future<bool> delete(Item item, int listId) async {
    final db = _db;
   
    try {
      db.delete(
        'ITEMS',
        where: 'LIST_ID = ? AND ID = ?',
        whereArgs: [listId, item.id],
      );
      print('Item deleted');
      return true;
    } catch (e) {
      print('Item deletion failed with error $e');
      return false;
    }
  }

  Future<bool> updateAll(List<Item> items, int listId) async {
    final db = _db;
   
    try {
      await db.transaction((txn) async {
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          await txn.rawUpdate(
            'UPDATE ITEMS SET '
            'NAME = ?, '
            'DESCRIPTION = ?, '
            'AMOUNT = ?, '
            'AMOUNT_UNIT = ?, '
            'ADDED_DATE = ?, '
            'IS_CHECKED = ? '
            'WHERE LIST_ID = ? AND ID = ?',
            [
              item.name,
              item.description,
              item.amount,
              item.amountUnit.index,
              item.addedDate,
              item.isChecked ? 1 : 0,
              listId,
              item.id,
            ],
          );
        }
      });

      return true;
    } catch (e) {
      print('Failed to update items, error = $e');
      return false;
    }
  }

  Future<bool> close() async {
    final db = _db;
    
    await db.close();
    return true;
  }
}
