import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'hacking_checklist_debug_v1.0.db');
    var db = await openDatabase(path, version: 1, onOpen: (db) {
      db.execute("PRAGMA foreign_keys = ON");
    }, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE CATEGORIES ('
        'id INTEGER PRIMARY KEY, '
        'category TEXT'
        ')');

    await db.execute('CREATE TABLE TARGETS ('
        'id INTEGER PRIMARY KEY, '
        'target_name TEXT, '
        'category_id INTEGER NOT NULL, '
        'FOREIGN KEY (category_id) REFERENCES CATEGORIES (id) ON UPDATE CASCADE ON DELETE CASCADE'
        ')');

    await db.execute('CREATE TABLE CHECKLISTS ('
        'id INTEGER PRIMARY KEY, '
        'task_name TEXT, '
        'status INTEGER NOT NULL, '
        'target_id INTEGER NOT NULL, '
        'FOREIGN KEY (target_id) REFERENCES TARGETS (id) ON UPDATE CASCADE ON DELETE CASCADE'
        ')');

    await db.execute('CREATE TABLE TASKS ('
        'id INTEGER PRIMARY KEY, '
        'task_name TEXT, '
        ')');
  }

  _onUpgrade(Database db, int previousVersion, int newVersion) async {
    // if(previousVersion < newVersion) {
    //   await db.execute('CREATE TABLE CHECKLISTS ('
    //       'id INTEGER PRIMARY KEY, '
    //       'task_name TEXT, '
    //       'status INTEGER, '
    //       'target_id INTEGER NOT NULL, '
    //       'FOREIGN KEY (target_id) REFERENCES TARGETS (id) ON UPDATE CASCADE ON DELETE CASCADE'
    //       ')');
    // }
  }


  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}