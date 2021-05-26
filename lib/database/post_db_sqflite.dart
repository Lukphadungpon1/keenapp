import 'package:keenapp/modal/mUser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'dart:io';

class PostDBSqflite {
  String databaseName;

  PostDBSqflite({this.databaseName});

  Future<sqflite.Database> openDatabase() async {
    var appDocumentDirectory = await getApplicationDocumentsDirectory();
    var databaseLocationInApp =
        join(appDocumentDirectory.path, this.databaseName);
    var database = await sqflite.openDatabase(
      databaseLocationInApp,
      version: 1,
      onCreate: (db, version) async {
        var sql =
            "CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT,empCode TEXT,empName TEXT,empLname TEXT,empSection TEXT,empPosition TEXT,empDepartment TEXT,empUsername TEXT,empPassword TEXT,empEmail TEXT)";

        await db.execute(sql);
      },
    );
    return database;
  }

  Future<int> save(mUser post) async {
    var database = await this.openDatabase();
    var sql =
        "INSERT INTO user (empCode,empName,empLname,empSection,empPosition,empDepartment,empUsername,empPassword,empEmail) VALUES (?,?,?,?,?,?,?,?,?)";

    var dataID = database.rawInsert(sql, [
      post.empCode,
      post.empName,
      post.empLname,
      post.empSection,
      post.empPosition,
      post.empDepartment,
      post.empUsername,
      post.empPassword,
      post.empEmail
    ]);

    return dataID;
  }

  Future<List<mUser>> loadUser() async {
    var database = await this.openDatabase();
    var sql = "SELECT * FROM user ORDER BY id DESC";
    var result = await database.rawQuery(sql);
    var userList = List<mUser>();
    for (var e in result) {
      var _user = mUser(
          empCode: e['empCode'],
          empName: e['empName'],
          empLname: e['empLname'],
          empSection: e['empSection'],
          empPosition: e['empPosition'],
          empDepartment: e['empDepartment'],
          empUsername: e['empUsername'],
          empPassword: e['empPassword'],
          empEmail: e['empEmail']);
      userList.add(_user);
    }

    return userList;
  }

  Future<bool> clearData() async {
    var database = await this.openDatabase();
    var sql = "DELETE FROM user ";
    await database.execute(sql);
    return true;
  }
}
