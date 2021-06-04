import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/domain/style/repositories/app_colors_repository.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/style/mappers/app_colors_scheme_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/style/repositories/app_colors_repository_impl.dart';

import '../../../fallback_values.dart';

class MockedAppColorsLocalDataSource extends Mock
    implements AppColorsLocalDataSource {}

class MockedAppColorsSchemeDaoMapper extends Mock
    implements AppColorsSchemeDaoMapper {}

void main() {
  late AppColorsLocalDataSource appColorsLocalDataSource;
  late AppColorsSchemeDaoMapper appColorsSchemeDaoMapper;
  late AppColorsRepository repository;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    appColorsLocalDataSource = MockedAppColorsLocalDataSource();
    appColorsSchemeDaoMapper = MockedAppColorsSchemeDaoMapper();
    repository = AppColorsRespositoryImpl(
      appColorsLocalDataSource,
      appColorsSchemeDaoMapper,
    );
  });

  test('should get colors scheme from data source and map it', () {
    final dto = AppColorsSchemeDao(backgroundColor: 0xFFFF9000);
    final model = AppColorsScheme(backgroundColor: 0xFFFF9000);
    when(() => appColorsLocalDataSource.getAppColorsScheme()).thenReturn(dto);
    when(() => appColorsSchemeDaoMapper.toModel(any())).thenReturn(model);

    final result = repository.getAppColors();

    expect(result, equals(model));
    verify(() => appColorsLocalDataSource.getAppColorsScheme()).called(1);
    verify(() => appColorsSchemeDaoMapper.toModel(dto)).called(1);
  });

  test('should map model and save it in data source', () {
    final dto = AppColorsSchemeDao(backgroundColor: 0xFFFF9000);
    final model = AppColorsScheme(backgroundColor: 0xFFFF9000);
    when(() => appColorsLocalDataSource.saveAppColorsScheme(any()))
        .thenAnswer((invocation) => Future.value());
    when(() => appColorsSchemeDaoMapper.fromModel(any())).thenReturn(dto);

    repository.saveAppColors(model);

    verify(() => appColorsLocalDataSource.saveAppColorsScheme(dto)).called(1);
    verify(() => appColorsSchemeDaoMapper.fromModel(model)).called(1);
  });
}
