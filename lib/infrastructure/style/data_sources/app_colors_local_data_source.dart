import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';

abstract class AppColorsLocalDataSource {
  AppColorsSchemeDao? getAppColorsScheme();

  Future<void> saveAppColorsScheme(AppColorsSchemeDao scheme);
}
