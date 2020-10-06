import 'package:hacking_checklist/database/db_helper.dart';
import 'package:hacking_checklist/database/model/MyChecklist.dart';
import 'package:sqflite/sqflite.dart';

class ChecklistRepository {
  Future<Database> db;

  ChecklistRepository(){
    db = DBHelper().db;
  }

  Future<bool> addChecklist(MyChecklist myChecklist) async {
    var dbClient = await db;
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM CHECKLISTS");
    int id = table.first['id'];
    myChecklist.id = id;
    dbClient.insert('CHECKLISTS', myChecklist.toMap());
    return true;
  }

  Future<List<MyChecklist>> getChecklistsOfTarget(int targetId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('CHECKLISTS', where: "target_id = ?", whereArgs: [targetId]);
    List<MyChecklist> checklists = [];
    for (Map map in maps){
      checklists.add(MyChecklist.fromMap(map));
    }
    return checklists;
  }

  Future<int> updateChecklist(MyChecklist myChecklist) async {
    var dbClient = await db;
    return await dbClient.update('CHECKLISTS', myChecklist.toMap(), where: "id = ?", whereArgs: [myChecklist.id]);
  }
}