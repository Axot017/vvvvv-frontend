import 'package:hive/hive.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source.dart';

const _colorsSchemeKey = 'colorsSchemeKey';

class AppColorsLocalDataSourceImpl implements AppColorsLocalDataSource {
  final Box<AppColorsSchemeDao> _colorsSchemeBox;

  AppColorsLocalDataSourceImpl(this._colorsSchemeBox);

  @override
  AppColorsSchemeDao? getAppColorsScheme() {
    return _colorsSchemeBox.get(_colorsSchemeKey);
  }

  @override
  Future<void> saveAppColorsScheme(AppColorsSchemeDao scheme) async {
    await _colorsSchemeBox.put(_colorsSchemeKey, scheme);
  }
}
