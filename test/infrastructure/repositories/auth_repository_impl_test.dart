import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/model/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/auth/repositories/auth_repository_impl.dart';

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
    registerFallbackValue(TokensPair(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    ));
    registerFallbackValue(TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    ));
    registerFallbackValue(TokensPairDto(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenValidFor: 123,
      refreshTokenValidFor: 123,
    ));
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
}
