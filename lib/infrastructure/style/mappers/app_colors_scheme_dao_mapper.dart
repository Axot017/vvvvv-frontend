import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';

class AppColorsSchemeDaoMapper {
  AppColorsScheme? toModel(AppColorsSchemeDao? dao) {
    if (dao == null) return null;
    return AppColorsScheme(backgroundColor: dao.backgroundColor);
  }

  AppColorsSchemeDao fromModel(AppColorsScheme model) {
    return AppColorsSchemeDao(backgroundColor: model.backgroundColor);
  }
}
