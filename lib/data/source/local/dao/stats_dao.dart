import 'package:covid19/data/models/stats.dart';

import '../database_manager.dart';
import 'base_dao.dart';

class StatsDao extends BaseDao<Stats> {
  static const String TABLE_NAME = "Stats";

  static const String FIELD_DATE = "date";
  static const String FIELD_NEW_CONFIRMED = "newConfirmed";
  static const String FIELD_TOTAL_CONFIRMED = "totalConfirmed";
  static const String FIELD_TOTAL_RECOVERED = "totalRecovered";
  static const String FIELD_TOTAL_DEATHS = "totalDeaths";

  @override
  String onCreateStatement() {
    return '''
      CREATE TABLE $TABLE_NAME (
        $FIELD_DATE TEXT PRIMARY KEY,
        $FIELD_NEW_CONFIRMED INTEGER NOT NULL,
        $FIELD_TOTAL_CONFIRMED INTEGER NOT NULL,
        $FIELD_TOTAL_RECOVERED INTEGER NOT NULL,
        $FIELD_TOTAL_DEATHS INTEGER NOT NULL
      );
    ''';
  }

  @override
  String getTableName() => TABLE_NAME;

  @override
  List<String> getPrimaryKeys() => [FIELD_DATE];

  @override
  Map<String, dynamic> mapObjectToRow(Stats obj) => {
        FIELD_DATE : obj.date,
        FIELD_NEW_CONFIRMED : obj.newConfirmed,
        FIELD_TOTAL_CONFIRMED : obj.totalConfirmed,
        FIELD_TOTAL_RECOVERED : obj.totalRecovered,
        FIELD_TOTAL_DEATHS : obj.totalDeaths,
      };

  @override
  Stats mapRowToObject(Map<String, dynamic> row) {
    return Stats(
      row[FIELD_DATE],
      row[FIELD_NEW_CONFIRMED],
      row[FIELD_TOTAL_CONFIRMED],
      row[FIELD_TOTAL_RECOVERED],
      row[FIELD_TOTAL_DEATHS],
    );
  }

  Future<String> getLastStat() async {
    var db = await DatabaseManager.instance.database;
    var rows = await db.rawQuery("""
      SELECT S.*
      FROM $TABLE_NAME S
      ORDER BY $FIELD_DATE DESC
      LIMIT 1
    """);
    if (rows == null || rows.isEmpty) return "2020-03-06";
    return mapRowToObject(rows[0]).date;
  }
}
