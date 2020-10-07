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

  Future<Task> getTaskByName({String taskName}) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('TASKS', where: "task_name = ?", whereArgs: [taskName]);
    return Task.fromMap(map[0]);
  }

  Future<Task> getTaskById({int id}) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('TASKS', where: "id = ?", whereArgs: [id]);
    return Task.fromMap(map[0]);
  }

  Future<int> deleteTask(String task) async {
    var dbClient = await db;
    return await dbClient.delete('TASKS', where: "task_name = ?", whereArgs: [task]);
  }

  Future<List<Task>> getAllTasks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('TASKS');
    List<Task> tasks = [];
    for (Map map in maps){
      tasks.add(Task.fromMap(map));
    }
    return tasks;
  }

  Future<int> updateTask(Task task) async {
    var dbClient = await db;
    return await dbClient.update('TASKS', task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }
}