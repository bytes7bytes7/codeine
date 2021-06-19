import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user.dart';
import '../constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, ConstantDBData.databaseName);
    return await openDatabase(path,
        version: ConstantDBData.databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstantDBData.userTableName} (
        ${ConstantDBData.id} INTEGER PRIMARY KEY,
        ${ConstantDBData.link} TEXT,
        ${ConstantDBData.name} TEXT,
        ${ConstantDBData.firstName} TEXT,
        ${ConstantDBData.lastName} TEXT,
        ${ConstantDBData.shortName} TEXT,
        ${ConstantDBData.sex} INTEGER,
        ${ConstantDBData.photo} TEXT,
        ${ConstantDBData.photo_100} TEXT,
        ${ConstantDBData.phoneOrEmail} TEXT
      )
    ''');
  }

  Future dropDB(String dbName) async {
    final db = await database;
    switch (dbName) {
      case ConstantDBData.userTableName:
        await db
            .execute('DROP TABLE IF EXISTS ${ConstantDBData.userTableName};');
        break;
      default:
        await db
            .execute('DROP TABLE IF EXISTS ${ConstantDBData.userTableName};');
        await _createDB(db, ConstantDBData.databaseVersion);
    }
  }

  // User methods
  Future _addUser(User user) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO ${ConstantDBData.userTableName} (${ConstantDBData.id}, ${ConstantDBData.link}, ${ConstantDBData.name}, ${ConstantDBData.firstName}, ${ConstantDBData.lastName}, ${ConstantDBData.shortName}, ${ConstantDBData.sex}, ${ConstantDBData.photo}, ${ConstantDBData.photo_100}, ${ConstantDBData.phoneOrEmail}) VALUES (?,?,?,?,?,?,?,?,?,?)",
      [
        user.id,
        user.link,
        user.name,
        user.firstName,
        user.lastName,
        user.shortName,
        user.sex,
        user.photo,
        user.photo_100,
        user.phoneOrEmail,
      ],
    );
  }

  Future updateUser(User user) async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        "${ConstantDBData.userTableName}",
        where: "${ConstantDBData.id} = ?",
        whereArgs: [user.id]);
    if (data.isNotEmpty) {
      Map<String, dynamic> map = user.toMap();
      await db.update("${ConstantDBData.userTableName}", map,
          where: "${ConstantDBData.id} = ?", whereArgs: [user.id]);
    }else{
      await _addUser(user);
    }

  }

  Future getUser(int id) async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        "${ConstantDBData.userTableName}",
        where: "${ConstantDBData.id} = ?",
        whereArgs: [id]);
    if (data.isNotEmpty) {
      User.fromMap(Map<String, dynamic>.from(data.first));
    }
  }

  Future deleteUser(int id) async {
    final db = await database;
    db.delete("${ConstantDBData.userTableName}",
        where: "${ConstantDBData.id} = ?", whereArgs: [id]);
  }
}
