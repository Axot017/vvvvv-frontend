import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/config/general_config.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokensPairDaoMapper _tokensPairDaoMapper;
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
  Future<TokensPair> login(String login, String password) async {
    final clientSecret = GeneralConfig.clientSecret;

    final dto = await _authRemoteDataSource.login(
      email: login,
      password: password,
      clientSecret: clientSecret,
    );

    final model = _tokensPairDtoMapper.toModel(dto);
    await _saveToken(model);

    return model;
  }

  @override
  Future<TokensPair> refreshToken(TokensPair tokensPair) async {
    final clientSecret = GeneralConfig.clientSecret;

    final dto = await _authRemoteDataSource.refreshToken(
      refreshToken: tokensPair.refreshToken,
      clientSecret: clientSecret,
    );

    final model = _tokensPairDtoMapper.toModel(dto);
    await _saveToken(model);

    return model;
  }

  Future<void> _saveToken(TokensPair model) async {
    final dao = _tokensPairDaoMapper.fromModel(model);
    await _authLocalDataSource.saveToken(dao);
  }
}
