import 'package:covid19/data/models/danger_zone.dart';
import 'package:covid19/data/models/stats.dart';
import 'package:covid19/data/source/local/dao/stats_dao.dart';
import 'package:covid19/data/source/remote/request_manager.dart';
import 'package:intl/intl.dart';

class DataSourceRepository {
  final RequestManager api = RequestManager();
  final StatsDao statsDao = StatsDao();

  Future<List<DangerZone>> listDangerZones() {
    return api.listDangerZones();
  }

  Future<Stats> getAndSaveStatOfDay(String day) async {
    try {
      final stats = await api.getStatsPerDay(day);
      await statsDao.insert(stats);
      return stats;
    } catch (error) {
      print("getAndSaveStatOfDay:" + error.toString());
      return null;
    }
  }

  Future<List<Stats>> getAllLocalStats() {
    return statsDao.queryAllRows();
  }

  Future<String> getLastStat() {
    return statsDao.getLastStat();
  }
}
