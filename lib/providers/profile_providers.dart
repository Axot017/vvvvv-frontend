import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/domain/profile/interactors/profile_interactor.dart';
import 'package:vvvvv_frontend/domain/profile/repositories/profile_repository.dart';
import 'package:vvvvv_frontend/infrastructure/profile/data_sources/profile_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/create_user_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/current_user_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/profile/repositories/profile_repository_impl.dart';
import 'package:vvvvv_frontend/providers/networking_providers.dart';

final profileInteractorProvider = Provider<ProfileInteractor>((ref) {
  final profileRepository = ref.watch(_profileRepositoryProvider);

  return ProfileInteractor(profileRepository);
});

final _profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final profileRemoteDataSource = ref.watch(_profileRemoteDataSourceProvider);
  final currentUserDtoMapper = ref.watch(_currentUserDtoMapperProvider);
  final withDioErrorMapperDecorator =
      ref.watch(withDioErrorMapperDecoretorProvider);
  final createUserDtoMapper = ref.watch(_createUserDtoMapperProvider);

  return ProfileRepositoryImpl(
    profileRemoteDataSource,
    currentUserDtoMapper,
    withDioErrorMapperDecorator,
    createUserDtoMapper,
  );
});

final _createUserDtoMapperProvider = Provider<CreateUserDtoMapper>((ref) {
  return CreateUserDtoMapper();
});

final _currentUserDtoMapperProvider = Provider<CurrentUserDtoMapper>((ref) {
  return CurrentUserDtoMapper();
});

final _profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(authenticatedDioProvider);

  return ProfileRemoteDataSource(dio);
});
