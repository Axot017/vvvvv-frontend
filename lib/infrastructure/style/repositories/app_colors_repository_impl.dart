import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/domain/style/repositories/app_colors_repository.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/style/mappers/app_colors_scheme_dao_mapper.dart';

class AppColorsRespositoryImpl implements AppColorsRepository {
  final AppColorsLocalDataSource _dataSource;
  final AppColorsSchemeDaoMapper _mapper;

  AppColorsRespositoryImpl(this._dataSource, this._mapper);

  @override
  AppColorsScheme? getAppColors() {
    final dao = _dataSource.getAppColorsScheme();

    return _mapper.toModel(dao);
  }

  @override
  Future<void> saveAppColors(AppColorsScheme scheme) async {
    final dto = _mapper.fromModel(scheme);

    await _dataSource.saveAppColorsScheme(dto);
  }
}
