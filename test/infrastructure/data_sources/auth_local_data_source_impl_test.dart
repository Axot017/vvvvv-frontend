import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source_impl.dart';

class MockedTokensBox extends Mock implements Box<TokensPairDao> {}

void main() {
  late Box<TokensPairDao> tokensBox;
  late AuthLocalDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    ));
  });

  setUp(() {
    tokensBox = MockedTokensBox();
    dataSource = AuthLocalDataSourceImpl(tokensBox);
  });

  test('should save tokens pair in box', () async {
    when(() => tokensBox.put(any(), any())).thenAnswer((_) => Future.value());
    final dao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );

    await dataSource.saveToken(dao);

    verify(() => tokensBox.put(any(), dao)).called(1);
  });

  test('should get tokens pair from box', () async {
    final dao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2020),
      refreshTokenExpiretionDate: DateTime(2021),
    );
    when(() => tokensBox.get(any())).thenReturn(dao);

    final result = await dataSource.getToken();

    expect(result, equals(dao));
  });

  test('should return null if there is no token in box', () async {
    when(() => tokensBox.get(any())).thenReturn(null);

    final result = await dataSource.getToken();

    expect(result, equals(null));
  });
}
