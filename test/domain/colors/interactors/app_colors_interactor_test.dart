import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/style/interactors/app_colors_interactor.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/domain/style/repositories/app_colors_repository.dart';

import '../../../fallback_values.dart';

class MockedAppColorsRepository extends Mock implements AppColorsRepository {}

void main() {
  late AppColorsRepository appColorsRepository;
  late AppColorsInteractor interactor;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    appColorsRepository = MockedAppColorsRepository();
    interactor = AppColorsInteractor(appColorsRepository);
  });

  test('should return scheme from repository', () {
    final scheme = AppColorsScheme.light();
    when(() => appColorsRepository.getAppColors()).thenReturn(scheme);

    final result = interactor.getColorsScheme();

    expect(result, equals(scheme));
    verify(() => appColorsRepository.getAppColors()).called(1);
  });

  test('should return dark scheme as default', () {
    final dartkTheme = AppColorsScheme.dark();
    when(() => appColorsRepository.getAppColors()).thenReturn(null);

    final result = interactor.getColorsScheme();

    expect(
      result,
      isA<AppColorsScheme>().having(
        (scheme) => scheme.backgroundColor,
        'backgroundColor',
        equals(dartkTheme.backgroundColor),
      ),
    );
    verify(() => appColorsRepository.getAppColors()).called(1);
  });

  test('should save colors scheme in repository', () async {
    final scheme = AppColorsScheme.light();
    when(() => appColorsRepository.saveAppColors(any()))
        .thenAnswer((_) => Future.value());

    await interactor.saveColorsScheme(scheme);

    verify(() => appColorsRepository.saveAppColors(scheme)).called(1);
  });
}
