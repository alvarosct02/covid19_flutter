import 'dart:async';

import 'package:covid19/data/source/data_source_repository.dart';
import 'package:flutter/foundation.dart';

class BaseBloc {
  @protected
  final DataSourceRepository repository;

  BaseBloc(this.repository);

  final List<StreamController> _controllers = [];

  @protected
  StreamController addController(StreamController controller) {
    _controllers.add(controller);
  }

  void dispose() {
    _controllers.forEach((c) => c.close());
  }
}
