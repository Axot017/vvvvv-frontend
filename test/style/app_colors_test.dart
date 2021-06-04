import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/style/interactors/app_colors_interactor.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/style/app_colors.dart';

import '../fallback_values.dart';

class MockedAppColorsInteractor extends Mock implements AppColorsInteractor {}

void main() {
  setUpAll(() {
    registerAllFallbackValues();
  });

  group('AppColorsNotifier', () {
    late AppColorsInteractor appColorsInteractor;
    late AppColorsNotifier notifier;

    setUp(() {
      appColorsInteractor = MockedAppColorsInteractor();
      when(() => appColorsInteractor.getColorsScheme())
          .thenReturn(AppColorsScheme.dark());
      notifier = AppColorsNotifier(appColorsInteractor);
    });

    test('should save new selected colors scheme and emit new state', () async {
      final newScheme = AppColorsScheme.light();
      when(() => appColorsInteractor.saveColorsScheme(any()))
          .thenAnswer((_) => Future.value());

      expectLater(
        notifier.stream,
        emits(
          isA<AppColors>().having(
            (colors) => colors.background.value,
            'background',
            equals(newScheme.backgroundColor),
          ),
        ),
      );

      notifier.changeColorsScheme(newScheme);
    });
  });

  group('AppColors', () {
    test('should create AppColors from AppColorsScheme', () {
      const testBackgroundColor = 0xFFFF9000;
      final scheme = AppColorsScheme(backgroundColor: testBackgroundColor);

      final appColors = AppColors.fromAppColorsScheme(scheme);

      expect(appColors.background.value, equals(testBackgroundColor));
    });
  });
}
