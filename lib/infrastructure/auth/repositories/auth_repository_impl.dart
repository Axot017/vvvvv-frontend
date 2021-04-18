import 'package:vvvvv_frontend/domain/auth/model/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokensPairDaoMapper _tokensPairDaoMapper;

  // ignore: unused_field
  final TokensPairDtoMapper _tokensPairDtoMapper;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(
    this._tokensPairDaoMapper,
    this._tokensPairDtoMapper,
    this._authLocalDataSource,
    this._authRemoteDataSource,
  );

  @override
  Future<TokensPair?> getSavedToken() async {
    final dao = await _authLocalDataSource.getToken();
    if (dao == null) {
      return null;
    } else {
      return _tokensPairDaoMapper.toModel(dao);
    }
  }

  @override
  Future<TokensPair> login(String login, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<TokensPair> refreshToken(TokensPair tokensPair) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
