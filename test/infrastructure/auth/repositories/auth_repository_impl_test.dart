import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/repositories/auth_repository_impl.dart';

import '../../../falback_values.dart';

class MockedTokensPairDaoMapper extends Mock implements TokensPairDaoMapper {}

class MockedTokensPairDtoMapper extends Mock implements TokensPairDtoMapper {}

class MockedAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockedAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late TokensPairDaoMapper tokensPairDaoMapper;
  late TokensPairDtoMapper tokensPairDtoMapper;
  late AuthLocalDataSource authLocalDataSource;
  late AuthRemoteDataSource authRemoteDataSource;
  late AuthRepository authRepository;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    tokensPairDaoMapper = MockedTokensPairDaoMapper();
    tokensPairDtoMapper = MockedTokensPairDtoMapper();
    authLocalDataSource = MockedAuthLocalDataSource();
    authRemoteDataSource = MockedAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(
      tokensPairDaoMapper,
      tokensPairDtoMapper,
      authLocalDataSource,
      authRemoteDataSource,
    );
  });

  test('should get token from local data source', () async {
    final dao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    final model = TokensPair(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    when(() => authLocalDataSource.getToken())
        .thenAnswer((_) => Future.value(dao));
    when(() => tokensPairDaoMapper.toModel(any())).thenReturn(model);

    final result = await authRepository.getSavedToken();

    expect(result, equals(model));
    verify(() => authLocalDataSource.getToken()).called(1);
    verify(() => tokensPairDaoMapper.toModel(dao)).called(1);
  });

  test('should return null if there are no token in local store', () async {
    when(() => authLocalDataSource.getToken())
        .thenAnswer((invocation) => Future.value());

    final result = await authRepository.getSavedToken();

    expect(result, equals(null));
    verify(() => authLocalDataSource.getToken()).called(1);
    verifyNever(() => tokensPairDaoMapper.toModel(any()));
  });

  test('should return tokens pair after login and save it to local storage',
      () async {
    final dto = TokensPairDto(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenValidFor: 123,
      refreshTokenValidFor: 123,
    );
    final model = TokensPair(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    final dao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    when(() => authRemoteDataSource.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          clientSecret: any(named: 'clientSecret'),
        )).thenAnswer((_) => Future.value(dto));
    when(() => tokensPairDtoMapper.toModel(any())).thenReturn(model);
    when(() => tokensPairDaoMapper.fromModel(any())).thenReturn(dao);
    when(() => authLocalDataSource.saveToken(any()))
        .thenAnswer((_) => Future.value());

    final result = await authRepository.login('login', 'password');

    expect(result, equals(model));
    verify(() => authRemoteDataSource.login(
          email: 'login',
          password: 'password',
          clientSecret: any(named: 'clientSecret'),
        )).called(1);
    verify(() => tokensPairDtoMapper.toModel(dto)).called(1);
    verify(() => tokensPairDaoMapper.fromModel(model)).called(1);
    verify(() => authLocalDataSource.saveToken(dao)).called(1);
  });

  test('should return tokens pair after refresh and save it to local storage',
      () async {
    final dto = TokensPairDto(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenValidFor: 123,
      refreshTokenValidFor: 123,
    );
    final lastToken = TokensPair(
      accessToken: 'lastAccessToken',
      refreshToken: 'lastRefreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    final model = TokensPair(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    final dao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    when(() => authRemoteDataSource.refreshToken(
          refreshToken: any(named: 'refreshToken'),
          clientSecret: any(named: 'clientSecret'),
        )).thenAnswer((_) => Future.value(dto));
    when(() => tokensPairDtoMapper.toModel(any())).thenReturn(model);
    when(() => tokensPairDaoMapper.fromModel(any())).thenReturn(dao);
    when(() => authLocalDataSource.saveToken(any()))
        .thenAnswer((_) => Future.value());

    final result = await authRepository.refreshToken(lastToken);

    expect(result, equals(model));
    verify(() => authRemoteDataSource.refreshToken(
          refreshToken: lastToken.refreshToken,
          clientSecret: any(named: 'clientSecret'),
        ));
    verify(() => tokensPairDtoMapper.toModel(dto)).called(1);
    verify(() => tokensPairDaoMapper.fromModel(model)).called(1);
    verify(() => authLocalDataSource.saveToken(dao)).called(1);
  });
}
