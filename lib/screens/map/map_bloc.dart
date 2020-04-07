import 'dart:async';

import 'package:covid19/data/models/danger_zone.dart';
import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_bloc.dart';


class MapBloc extends BaseBloc {

  final _zoneList = StreamController<List<DangerZone>>();

  Stream<List<DangerZone>> get zoneListObservable => _zoneList.stream;

  MapBloc(DataSourceRepository repository) : super(repository) {
    addController(_zoneList);
  }

  void listZones() async {
    try {
      var zones = await repository.listDangerZones();
      _zoneList.sink.add(zones);
    } catch (error) {
      print("ASCT: ${error.toString()}");
    }
  }
}
