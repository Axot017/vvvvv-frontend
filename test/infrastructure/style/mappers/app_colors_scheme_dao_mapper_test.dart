import 'package:flutter_test/flutter_test.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/mappers/app_colors_scheme_dao_mapper.dart';

import '../../../fallback_values.dart';

void main() {
  late AppColorsSchemeDaoMapper mapper;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    mapper = AppColorsSchemeDaoMapper();
  });

  group('toModel', () {
    test('should return null if dao is null', () {
      final result = mapper.toModel(null);

      expect(result, equals(null));
    });

    test('should return mapped color scheme', () {
      const color = 0xFFFF9000;

      final result = mapper.toModel(AppColorsSchemeDao(backgroundColor: color));

      expect(result?.backgroundColor, equals(color));
    });
  });

  group('fromModel', () {
    test('should return mapped color scheme', () {
      const color = 0xFFFF9000;

      final result = mapper.fromModel(AppColorsScheme(backgroundColor: color));

      expect(result.backgroundColor, equals(color));
    });
  });
}
