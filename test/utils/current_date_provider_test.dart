import 'package:flutter_test/flutter_test.dart';
import 'package:vvvvv_frontend/utils/current_date_provider.dart';

import '../fallback_values.dart';

void main() {
  late CurrentDateProvider dateProvider;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    dateProvider = CurrentDateProvider();
  });
  test('should return current date', () {
    final result = dateProvider.getCurrentDate();

    final expectedDate = DateTime.now();
    expect(result.isAtSameMomentAs(expectedDate), isTrue);
  });
}
