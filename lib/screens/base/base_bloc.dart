import 'dart:async';

import 'package:covid19/data/source/data_source_repository.dart';
import 'package:flutter/foundation.dart';

class BaseBloc<E> {
  @protected
  final DataSourceRepository repository;

  BaseBloc(this.repository);

  final _eventQueue = StreamController<E>();
  Stream<E> get eventObservable => _eventQueue.stream;

  @protected
  void addEvent(E event) {
    _eventQueue.sink.add(event);
  }

  void dispose() {
    _eventQueue.close();
  }
}
