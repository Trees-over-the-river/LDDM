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
    print('Opening ItemListDB at $databasesPath/$path');

    _db = await openDatabase('$databasesPath/$path',
        version: 1,
        onCreate: (db, version) => db.execute(
              '''CREATE TABLE IF NOT EXISTS ITEMLIST (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    NAME STRING NOT NULL,
                    
                  )''',
            ));

    print('ItemListDB opened (db = $_db)');
  }
}
