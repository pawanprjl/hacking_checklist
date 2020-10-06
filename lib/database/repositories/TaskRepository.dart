import 'package:hacking_checklist/database/db_helper.dart';
import 'package:hacking_checklist/database/model/Tasks.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository {
  Future<Database> db;

  TaskRepository() {
    db = DBHelper().db;
  }

  Future<bool> addTask(Task task) async{
    var dbClient = await db;
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM TASKS");
    int id = table.first['id'];
    task.id = id;
    dbClient.insert('TASKS', task.toMap());
    return true;
  }
}