import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/config/hive_config.dart';
import 'package:vvvvv_frontend/domain/style/interactors/app_colors_interactor.dart';
import 'package:vvvvv_frontend/domain/style/repositories/app_colors_repository.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/style/data_sources/app_colors_local_data_source_impl.dart';
import 'package:vvvvv_frontend/infrastructure/style/mappers/app_colors_scheme_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/style/repositories/app_colors_repository_impl.dart';
import 'package:vvvvv_frontend/style/app_colors.dart';

final appColorsProvider =
    StateNotifierProvider<AppColorsNotifier, AppColors>((ref) {
  final interactor = ref.watch(_appColorsInteractorProvider);

  return AppColorsNotifier(interactor);
});

final _appColorsInteractorProvider = Provider<AppColorsInteractor>((ref) {
  final repository = ref.watch(_appColorsRepositoryProvider);

  return AppColorsInteractor(repository);
});

final _appColorsRepositoryProvider = Provider<AppColorsRepository>((ref) {
  final localDataSource = ref.watch(_appColorsLocalDataSourceProvider);
  final mapper = ref.watch(_appColorsSchemeDaoMapperProvider);

  return AppColorsRespositoryImpl(localDataSource, mapper);
});

final _appColorsSchemeDaoMapperProvider =
    Provider<AppColorsSchemeDaoMapper>((ref) {
  return AppColorsSchemeDaoMapper();
});

final _appColorsLocalDataSourceProvider =
    Provider<AppColorsLocalDataSource>((ref) {
  final box = ref.watch(_appColorsBoxProvider);

  return AppColorsLocalDataSourceImpl(box);
});

final _appColorsBoxProvider = Provider<Box<AppColorsSchemeDao>>((ref) {
  return Hive.box(HiveConfig.appColorsBoxName);
});
