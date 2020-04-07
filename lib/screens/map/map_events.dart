
import 'package:covid19/data/models/danger_zone.dart';

abstract class MapEvent {}

class OnDataEvent extends MapEvent {
  List<DangerZone> dangerZones;
  OnDataEvent(this.dangerZones);
}

class OnErrorEvent extends MapEvent {
  String message;
  OnErrorEvent(this.message);
}
