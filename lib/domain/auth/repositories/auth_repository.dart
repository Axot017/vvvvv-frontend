import 'package:vvvvv_frontend/domain/auth/model/tokens_pair.dart';

abstract class AuthRepository {
  Future<TokensPair> login(String login, String password);

  Future<TokensPair> refreshToken(TokensPair tokensPair);

  Future<TokensPair?> getSavedToken();
}
