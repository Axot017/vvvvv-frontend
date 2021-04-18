import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(TokensPairDao tokensPairDao);

  Future<TokensPairDao?> getToken();
}
