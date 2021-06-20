import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/interactors/auth_interactor.dart';
import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';

import '../../../fallback_values.dart';

class MockedAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;
  late AuthInteractor interactor;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    authRepository = MockedAuthRepository();
    interactor = AuthInteractor(authRepository);
  });

  test('should use repository to refresh tokens', () async {
    final currentToken = TokensPair(
      accessToken: 'testAccessToken',
      accessTokenExpirationDate: DateTime(2050),
      refreshToken: 'testRefreshToken',
      refreshTokenExpiretionDate: DateTime(2100),
    );
    final newToken = TokensPair(
      accessToken: 'testAccessToken2',
      accessTokenExpirationDate: DateTime(2150),
      refreshToken: 'testRefreshToken2',
      refreshTokenExpiretionDate: DateTime(2200),
    );
    when(() => authRepository.refreshToken(any()))
        .thenAnswer((_) => Future.value(newToken));

    final result = await interactor.refreshToken(currentToken);

    expect(result, equals(newToken));
    verify(() => authRepository.refreshToken(currentToken)).called(1);
  });

  test('should get current token from repository', () async {
    final currentToken = TokensPair(
      accessToken: 'testAccessToken',
      accessTokenExpirationDate: DateTime(2050),
      refreshToken: 'testRefreshToken',
      refreshTokenExpiretionDate: DateTime(2100),
    );
    when(() => authRepository.getSavedToken())
        .thenAnswer((_) => Future.value(currentToken));

    final result = await interactor.getTokensPair();

    expect(result, equals(currentToken));
    verify(() => authRepository.getSavedToken()).called(1);
  });
}
