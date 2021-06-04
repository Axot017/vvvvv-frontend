import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/domain/style/interactors/app_colors_interactor.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';

class AppColorsNotifier extends StateNotifier<AppColors> {
  final AppColorsInteractor _interactor;

  AppColorsNotifier(this._interactor)
      : super(AppColors.fromAppColorsScheme(_interactor.getColorsScheme()));

  Future<void> changeColorsScheme(AppColorsScheme scheme) async {
    await _interactor.saveColorsScheme(scheme);
    state = AppColors.fromAppColorsScheme(scheme);
  }
}

class AppColors {
  final Color background;

  AppColors({required this.background});

  AppColors.fromAppColorsScheme(AppColorsScheme scheme)
      : background = Color(scheme.backgroundColor);
}
