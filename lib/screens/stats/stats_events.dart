import 'package:covid19/data/models/stats.dart';

abstract class StatsEvent {}

class OnDataEvent extends StatsEvent {
  List<Stats> stats;
  OnDataEvent(this.stats);
}

class OnStatSelectedEvent extends StatsEvent {
  Stats selected;
  OnStatSelectedEvent(this.selected);
}

class OnErrorEvent extends StatsEvent {
  String message;
  OnErrorEvent(this.message);
}
