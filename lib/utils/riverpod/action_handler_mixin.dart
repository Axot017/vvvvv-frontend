import 'dart:async';

import 'package:meta/meta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin ActionHandler<STATE, ACTION> on StateNotifier<STATE> {
  final _streamController = StreamController<ACTION>.broadcast();

  Stream<ACTION> get actionStream => _streamController.stream;

  @protected
  void addAction(ACTION action) => _streamController.add(action);

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
