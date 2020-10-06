import 'package:hacking_checklist/database/db_helper.dart';
import 'package:hacking_checklist/database/model/MyCategories.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository{
  Future<Database> db;

  CategoryRepository() {
    db = DBHelper().db;
  }

  Future<bool> addCategory(MyCategory myCategory) async {
    var dbClient = await db;
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM CATEGORIES");
    int id = table.first['id'];
    myCategory.id = id;
    dbClient.insert('CATEGORIES', myCategory.toMap());
    return true;
  }

  Future<MyCategory> getCategoryByName({String categoryName}) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('CATEGORIES', where: "category = ?", whereArgs: [categoryName]);
    return MyCategory.fromMap(map[0]);
  }

  Future<MyCategory> getCategoryById(int id) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query('CATEGORIES', where: "category = ?", whereArgs: [id]);
    return MyCategory.fromMap(map[0]);
  }

  Future<int> deleteCategory(String category) async {
    var dbClient = await db;
    return await dbClient.delete('CATEGORIES', where: "category = ?", whereArgs: [category]);
  }


  Future<List<MyCategory>> getAllCategories() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('CATEGORIES');
    List<MyCategory> myCategories = [];
    if(maps.length > 0){
      for (Map map in maps){
        myCategories.add(MyCategory.fromMap(map));
      }
    }
    return myCategories;
  }

  Future<int> updateCategory(MyCategory myCategory) async {
    var dbClient = await db;
    return await dbClient.update('CATEGORIES', myCategory.toMap(), where: "id = ?", whereArgs: [myCategory.id]);
  }
}