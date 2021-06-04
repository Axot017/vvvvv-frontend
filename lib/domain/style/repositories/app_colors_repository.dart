import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';

abstract class AppColorsRepository {
  AppColorsScheme? getAppColors();

  Future<void> saveAppColors(AppColorsScheme scheme);
}
