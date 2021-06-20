import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/utils/riverpod/action_manager_mixin.dart';

import '../../fallback_values.dart';

class TestStateNotifier extends StateNotifier<String>
    with ActionManager<String, int> {
  TestStateNotifier() : super('Test');

  void addTestAction(int action) {
    addAction(action);
  }
}

void main() {
  late TestStateNotifier testStateNotifier;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    testStateNotifier = TestStateNotifier();
  });

  test('should emit added actions', () {
    const actions = [1, 2, 2, 2, 6];

    expectLater(testStateNotifier.actionStream, emitsInOrder(actions));

    for (final element in actions) {
      testStateNotifier.addTestAction(element);
    }
  });
}
