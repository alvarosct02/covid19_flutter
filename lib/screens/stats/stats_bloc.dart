import 'dart:async';

import 'package:covid19/data/models/stats.dart';
import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_bloc.dart';
import 'package:intl/intl.dart';

class StatsBloc extends BaseBloc {
  final _statList = StreamController<List<Stats>>();
  final _selected = StreamController<Stats>();

  Stream<List<Stats>> get statListObservable => _statList.stream;
  Stream<Stats> get selectedObservable => _selected.stream;

  StatsBloc(DataSourceRepository repository) : super(repository) {
    addController(_statList);
    addController(_selected);
  }

  void listStats() async {
    var _stats = await repository.getAllLocalStats();

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

      _statList.sink.add(_stats);
      _selected.sink.add(_stats.last);

      if (currentDay.day == today.day && currentDay.month == today.month) {
        break;
      }

      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  void selectDate(Stats selectedStat) {
    _updateSelection(selectedStat);
  }

  // -----------------

  void _updateChart(List<Stats> _stats) {
    _statList.sink.add(_stats);
    _updateSelection(_stats.last);
  }

  void _updateSelection(Stats _stat) {
    _selected.sink.add(_stat);
  }
}
