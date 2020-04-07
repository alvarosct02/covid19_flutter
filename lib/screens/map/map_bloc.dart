import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_bloc.dart';

import 'map_events.dart';

class MapBloc extends BaseBloc<MapEvent> {
  MapBloc(DataSourceRepository repository) : super(repository);

  void listZones() async {
    try {
      var zones = await repository.listDangerZones();
      addEvent(OnDataEvent(zones));
    } catch (error) {
      addEvent(OnErrorEvent("Error"));
    }
  }
}
