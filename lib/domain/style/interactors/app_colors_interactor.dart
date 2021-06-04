import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/domain/style/repositories/app_colors_repository.dart';

class AppColorsInteractor {
  final AppColorsRepository _repository;

  AppColorsInteractor(this._repository);

  AppColorsScheme getColorsScheme() {
    return _repository.getAppColors() ?? _defaultScheme;
  }

  Future<void> saveColorsScheme(AppColorsScheme scheme) async {
    await _repository.saveAppColors(scheme);
  }

  AppColorsScheme get _defaultScheme => AppColorsScheme.dark();
}
