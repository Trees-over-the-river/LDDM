import 'dart:async';

import 'package:pricely/model/list.dart';
import 'package:sqflite/sqflite.dart';

class ListDB {
  static Database? _db;

  ListDB();

  ListDB.open(path) {
    open(path);
  }

  Future<void> open(String path) async {
    var databasesPath = await getDatabasesPath();
    print('Opening ListDB at $databasesPath/$path');

    _db = await openDatabase('$databasesPath/$path',
        version: 1,
        onCreate: (db, version) => db.execute(
              '''CREATE TABLE IF NOT EXISTS LISTS (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    NAME STRING NOT NULL
                  )''',
            ));

    print('ListDB opened (db = $_db)');
  }
  
  Future<List<ItemList>> fetchItemLists() async {
    if (_db == null) {
      return [];
    }

    try {
      final read = await _db!.query('LISTS',
          distinct: true,
          columns: [
            'ID',
            'NAME',
          ],
          orderBy: 'NAME');


      return read.map((row) {
        print(row);
        return ItemList.fromRow(row);
      }).toList();
    } catch (e) {
      print('Error fetching lists = $e');
      return [];
    }
  }

  Future<bool> create(ItemList list) async {
    print('Creating List (db = $_db)');

    final db = _db;
    if (db == null) {
      print('List database is null');
      return false;
    }

    try {
      await db.insert('LISTS', {
        'ID': list.id,
        'NAME': list.name,
      });
      print('List created');
    } catch (e) {
      print('Error in creating List = $e');
      return false;
    }

    return true;
  }

  Future<bool> update(ItemList list) async {
    final db = _db;
    if(db == null) {
      return false;
    }

    try {
      db.update('LISTS', {
        'NAME': list.name,
      },
      where: 'ID = ?',
      whereArgs: [list.id],
      ); 
      return true;
    } catch (e) {
      print('Failed to update list, error = $e');
      return false;
    }
  }

  Future<bool> delete(ItemList list) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      db.delete(
        'LISTS',
        where: 'ID = ?',
        whereArgs: [list.id],
      );
      print('List deleted');
      return true;
    } catch (e) {
      print('List deletion failed with error $e');
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
