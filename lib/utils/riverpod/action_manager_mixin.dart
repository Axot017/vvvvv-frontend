import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meta/meta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void useActionListener<STATE, ACTION>(
  ActionManager<STATE, ACTION> actionHandler,
  void Function(ACTION) onAction,
) {
  useEffect(() {
    final subscription = actionHandler.actionStream.listen((event) {
      onAction(event);
    });

    return subscription.cancel;
  });
}

mixin ActionManager<STATE, ACTION> on StateNotifier<STATE> {
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
