import 'dart:io';
import 'package:keenapp/modal/mUser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class PostDB {
  String databaseName;

  PostDB(this.databaseName);

  Future<Database> openDatabase() async {
    Directory appDocumentDir = await getApplicationDocumentsDirectory();
    String DatabaseLocationInapp = join(appDocumentDir.path, this.databaseName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(DatabaseLocationInapp);
    return db;
  }

  Future<int> save(mUser post) async {
    var database = await this.openDatabase();
    var postStore = intMapStoreFactory.store('user');

    var dataId = await postStore.add(database, mUser.toJson(post));
    await database.close();
    return dataId;
  }

  Future<List<mUser>> loadUser() async {
    var database = await this.openDatabase();
    var postStore = intMapStoreFactory.store('user');
    var snapshots = await postStore.find(database);

    var userList = List<mUser>();
    snapshots.forEach((element) {
      var post = mUser.fromRecord(element);

      userList.add(mUser.fromRecord(element));
    });

    return userList;
  }

  Future<bool> clearData() async {
    var database = await this.openDatabase();
    var postStore = intMapStoreFactory.store('user');
    await postStore.drop(database);
    return true;
  }
}
