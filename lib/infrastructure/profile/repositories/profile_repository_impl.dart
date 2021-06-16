import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';
import 'package:vvvvv_frontend/domain/profile/repositories/profile_repository.dart';
import 'package:vvvvv_frontend/infrastructure/networking/decorators/with_dio_error_mapper_decorator.dart';
import 'package:vvvvv_frontend/infrastructure/profile/data_sources/profile_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/create_user_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/current_user_dto_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final CurrentUserDtoMapper _currentUserDtoMapper;
  final WithDioErrorMapperDecorator _withDioErrorMapper;
  final CreateUserDtoMapper _createUserDtoMapper;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._currentUserDtoMapper,
    this._withDioErrorMapper,
    this._createUserDtoMapper,
  );

  @override
  Future<void> createUser(CreateUserModel model) async {
    final dto = _createUserDtoMapper.fromModel(model);
    await _withDioErrorMapper(() => _remoteDataSource.createUser(dto));
  }

  @override
  Future<CurrentUser> getCurrentUser() async {
    final result = await _withDioErrorMapper(_remoteDataSource.getCurrentUser);
    return _currentUserDtoMapper.toModel(result);
  }
}
