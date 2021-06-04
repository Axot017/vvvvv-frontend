import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source_impl.dart';

import '../../../fallback_values.dart';

class MockedAppColorsSchemeBox extends Mock implements Box<AppColorsSchemeDao> {
}

void main() {
  late Box<AppColorsSchemeDao> appColorsSchemeBox;
  late AppColorsLocalDataSource dataSource;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    appColorsSchemeBox = MockedAppColorsSchemeBox();
    dataSource = AppColorsLocalDataSourceImpl(appColorsSchemeBox);
  });

  test('should get colors scheme from box', () {
    final dao = AppColorsSchemeDao(backgroundColor: 0xFFFF9000);
    when(() => appColorsSchemeBox.get(any())).thenReturn(dao);

    final result = dataSource.getAppColorsScheme();

    expect(result, equals(dao));
    verify(() => appColorsSchemeBox.get(any())).called(1);
  });

  test('should save colors scheme in the box', () async {
    final dao = AppColorsSchemeDao(backgroundColor: 0xFFFF9000);
    when(() => appColorsSchemeBox.put(any(), any()))
        .thenAnswer((invocation) => Future.value());

    await dataSource.saveAppColorsScheme(dao);

    verify(() => appColorsSchemeBox.put(any(), dao)).called(1);
  });
}
