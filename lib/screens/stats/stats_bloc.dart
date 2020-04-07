import 'dart:async';

import 'package:covid19/data/models/stats.dart';
import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_bloc.dart';
import 'package:intl/intl.dart';

import 'stats_events.dart';

class StatsBloc extends BaseBloc<StatsEvent> {
  StatsBloc(DataSourceRepository repository) : super(repository);

  final _selectedStatQueue = StreamController<Stats>();
  Stream<Stats> get selectedStatObservable => _selectedStatQueue.stream;

  void listStats() async {
    var _stats = await repository.getAllLocalStats();
    addEvent(OnDataEvent(_stats));

    final format = DateFormat("yyyyMMdd");
    final today = DateTime.now();
    final lastSync = await repository.getLastStat();
    var currentDay = DateTime.parse(lastSync);

    while (true) {
      final dayFormatted = format.format(currentDay);
      var newZone = await repository.getAndSaveStatOfDay(dayFormatted);

      if (newZone != null) {
        _stats.removeWhere((z) => z.date == newZone.date);
        _stats.add(newZone);
      }
      addEvent(OnDataEvent(_stats));
      _selectedStatQueue.sink.add(_stats.last);

      if (currentDay.day == today.day && currentDay.month == today.month) {
        break;
      }

      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  void selectDate(DateTime date, List<Stats> stats) {
    var _selectedStat = stats
        .firstWhere((s) => s.date == DateFormat("yyyy-MM-dd").format(date));
    _selectedStatQueue.sink.add(_selectedStat);
  }

  @override
  void dispose() {
    _selectedStatQueue.close();
    super.dispose();
  }
}
