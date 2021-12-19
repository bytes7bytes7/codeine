import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Future<Database> get database;

  Future<void> init(String table, Map<String, Map<Type, bool>> fields);

  Future<void> dropTable(String table, Map<String, Map<Type, bool>> fields);

  Future<Map<String, Object?>> getNote(
      String table, Map<String, Object> params);

  Future<List<Map<String, Object?>>> getNotes(
      String table, Map<String, List<Object>> params);

  Future<void> addNote(String table, Map<String, Object?> map);

  Future<void> addNotes(String table, List<Map<String, Object?>> lst);

  Future<void> updateNote(
      String table, Map<String, Object?> map, Map<String, Object> params);

  Future<void> deleteNote(String table, Map<String, Object> params);

  Future<void> deleteNotes(String table, Map<String, List<Object>> params);
}
