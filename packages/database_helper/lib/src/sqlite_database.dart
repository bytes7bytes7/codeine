import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';
import 'constants.dart' as constants;

class SQLiteDatabase implements DatabaseHelper {
  SQLiteDatabase._();

  final int version = 1;
  static final SQLiteDatabase instance = SQLiteDatabase._();
  Database? _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _createDatabase();
    return _database!;
  }

  Future<Database> _createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, constants.databaseName);
    final db = await openDatabase(
      path,
      version: version,
    );
    // IMPORTANT: this line disables journal_mode
    db.rawQuery('PRAGMA JOURNAL_MODE = DELETE');
    return db;
  }

  @override
  Future<void> init(String table, Map<String, Map<Type, bool>> fields,
      [bool firstPrimaryKey = true]) async {
    final db = await database;
    String sql = 'CREATE TABLE IF NOT EXISTS $table (';
    for (var entity in fields.entries) {
      String key = entity.key;
      String nullable = entity.value.values.first ? '' : 'NOT NULL';
      String type = '';
      switch (entity.value.keys.first) {
        case int:
          type = 'INTEGER';
          break;
        case String:
          type = 'TEXT';
          break;
        case double:
          type = 'REAL';
          break;
      }
      if (firstPrimaryKey && entity.key == fields.entries.first.key) {
        type += ' PRIMARY KEY';
      }
      sql += '$key $type $nullable,';
    }
    sql = sql.substring(0, sql.length - 1) + ')';
    await db.execute(sql);
  }

  @override
  Future<void> dropTable(
      String table, Map<String, Map<Type, bool>> fields) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $table;');
    await init(table, fields);
  }

  @override
  Future<Map<String, Object?>> getNote(
      String table, Map<String, Object> params) async {
    final db = await database;
    var data = await db.query(table,
        where: '${params.keys.first} = ?', whereArgs: [params.values.first]);
    if (data.isEmpty) {
      return {};
    }
    return data.first;
  }

  @override
  Future<List<Map<String, Object?>>> getNotes(String table,
      [Map<String, List<Object>> params = const {}]) async {
    final db = await database;
    if (params.isEmpty) {
      return await db.query(table);
    }
    List<Map<String, Object?>> lst = [];
    List<Object> prev = [];
    String key = params.keys.first;
    for (Object obj in params.values.first) {
      int i = prev.indexOf(obj);
      if (i != -1) {
        lst.add(lst[i]);
      } else {
        lst.add(await getNote(table, {key: obj}));
      }
    }
    return lst;
  }

  @override
  Future<void> addNote(String table, Map<String, Object?> map) async {
    final db = await database;
    await db.insert(table, map);
  }

  @override
  Future<void> addNotes(String table, List<Map<String, Object?>> lst) async {
    final db = await database;
    await db.transaction((txn) async {
      for (Map<String, Object?> map in lst) {
        // maybe I don't need to await
        await txn.insert(table, map);
      }
    });
  }

  @override
  Future<void> updateNote(String table, Map<String, Object?> map,
      Map<String, Object> params) async {
    final db = await database;
    await db.update(
      table,
      map,
      where: '${params.keys.first} = ?',
      whereArgs: [params.values.first],
    );
  }

  @override
  Future<void> deleteNote(String table, Map<String, Object> params) async {
    final db = await database;
    await db.delete(
      table,
      where: '${params.keys.first} = ?',
      whereArgs: [params.values.first],
    );
  }

  // TODO: try it
  @override
  Future<void> deleteNotes(
      String table, Map<String, List<Object>> params) async {
    final db = await database;
    await db.delete(
      table,
      where: '${params.keys.first} IN (?)',
      whereArgs: params.values.first,
    );
  }
}
