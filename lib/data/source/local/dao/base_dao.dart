import 'package:sqflite/sqflite.dart';
import '../database_manager.dart';

abstract class BaseDao<T> {
  String onCreateStatement();

  String getTableName();

  List<String> getPrimaryKeys();

  Map<String, dynamic> mapObjectToRow(T obj);

  T mapRowToObject(Map<String, dynamic> row);

  Future<int> insert(T obj) async {
    var row = mapObjectToRow(obj);
    var db = await DatabaseManager.instance.database;
    return db.insert(getTableName(), row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAll(List<T> objList) async {
    var db = await DatabaseManager.instance.database;
    Batch batch = db.batch();
    objList.forEach((obj) {
      var row = mapObjectToRow(obj);
      batch.insert(getTableName(), row, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    return batch.commit(noResult: true);
  }

  Future<List<T>> queryAllRows() async {
    var db = await DatabaseManager.instance.database;
    var rows = await db.query(getTableName());
    return rows.map((row) => mapRowToObject(row)).toList();
  }

  Future<int> queryRowCount() async {
    var db = await DatabaseManager.instance.database;
    var rows = await db.rawQuery('SELECT COUNT(*) FROM ${getTableName()}');
    return Sqflite.firstIntValue(rows);
  }

  Future<int> update(T obj) async {
    var row = mapObjectToRow(obj);
    String _where = getPrimaryKeys().map((key) => '$key = ?').join(" AND ");
    List<dynamic> _whereArgs = getPrimaryKeys().map((key) => row[key]).toList();
    var db = await DatabaseManager.instance.database;
    return db.update(getTableName(), row, where: _where, whereArgs: _whereArgs);
  }

  Future<int> delete(T obj) async {
    var row = mapObjectToRow(obj);
    String _where = getPrimaryKeys().map((key) => '$key = ?').join(" AND ");
    List<dynamic> _whereArgs = getPrimaryKeys().map((key) => row[key]).toList();
    var db = await DatabaseManager.instance.database;
    return db.delete(getTableName(), where: _where, whereArgs: _whereArgs);
  }
}
