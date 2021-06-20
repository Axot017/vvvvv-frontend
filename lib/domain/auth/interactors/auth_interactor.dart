import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';

class AuthInteractor {
  final AuthRepository _authInteractor;

  AuthInteractor(this._authInteractor);

  Future<void> logout() async {}

  Future<TokensPair> refreshToken(TokensPair tokensPair) {
    return _authInteractor.refreshToken(tokensPair);
  }

  Future<TokensPair?> getTokensPair() {
    return _authInteractor.getSavedToken();
  }
}
