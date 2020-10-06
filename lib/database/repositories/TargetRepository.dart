import 'package:hacking_checklist/database/db_helper.dart';
import 'package:hacking_checklist/database/model/MyTargets.dart';
import 'package:sqflite/sqflite.dart';

class TargetRepository{
  Future<Database> db;

  TargetRepository() {
    db = DBHelper().db;
  }

  Future<bool> addTarget(MyTarget myTarget) async {
    var dbClient = await db;
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM TARGETS");
    int id = table.first['id'];
    myTarget.id = id;
    dbClient.insert('TARGETS', myTarget.toMap());
    return true;
  }

  Future<MyTarget> getTargetByName({String targetName}) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('TARGETS', where: "target_name = ?", whereArgs: [targetName]);
    return MyTarget.fromMap(map[0]);
  }

  Future<MyTarget> getTargetById(int id) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('TARGETS', where: "id = ?", whereArgs: [id]);
    return MyTarget.fromMap(map[0]);
  }

  Future<int> deleteTarget(String target) async {
    var dbClient = await db;
    return await dbClient.delete('TARGETS', where: "target_name = ?", whereArgs: [target]);
  }

  Future <List<MyTarget>> getTargetsOfCategory(int categoryId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('TARGETS', where: "category_id = ?", whereArgs: [categoryId]);
    List<MyTarget> targets = [];
    for (Map map in maps){
      targets.add(MyTarget.fromMap(map));
    }

    return targets;
  }


  Future<List<MyTarget>> getAllTargets() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('TARGETS');
    List<MyTarget> myTargets = [];
    if(maps.length > 0){
      for (Map map in maps){
        myTargets.add(MyTarget.fromMap(map));
      }
    }
    return myTargets;
  }

  Future<int> updateTarget(MyTarget myTarget) async {
    var dbClient = await db;
    return await dbClient.update('TARGETS', myTarget.toMap(), where: "id = ?", whereArgs: [myTarget.id]);
  }
}