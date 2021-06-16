import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/config/hive_config.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source_impl.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/repositories/auth_repository_impl.dart';
import 'package:vvvvv_frontend/providers/networking_providers.dart';
import 'package:vvvvv_frontend/providers/utils_providers.dart';

final authInteractorProvider = Provider<AuthInteractor>((ref) {
  final authRepository = ref.watch(_authRepositoryProvider);

  return AuthInteractor(authRepository);
});

final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokensPairDaoMapper = ref.watch(_tokensPairDaoMapperProvider);
  final tokensPairDtoMapper = ref.watch(_tokensPairDtoMapperProvider);
  final authRemoteDataSource = ref.watch(_authRemoteDataSourceProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(
    tokensPairDaoMapper,
    tokensPairDtoMapper,
    authLocalDataSource,
    authRemoteDataSource,
  );
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final box = ref.watch(_authBoxProvider);

  return AuthLocalDataSourceImpl(box);
});

final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(unauthenticatedDioProvider);

  return AuthRemoteDataSource(dio);
});

final _tokensPairDtoMapperProvider = Provider<TokensPairDtoMapper>((ref) {
  final dateProvider = ref.watch(currentDateProvider);

  return TokensPairDtoMapper(dateProvider);
});

final _tokensPairDaoMapperProvider = Provider<TokensPairDaoMapper>((ref) {
  return TokensPairDaoMapper();
});

final _authBoxProvider = Provider<Box<TokensPairDao>>((ref) {
  return Hive.box(HiveConfig.tokensPairBoxName);
});
