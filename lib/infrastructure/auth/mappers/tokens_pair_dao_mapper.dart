import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';

class TokensPairDaoMapper {
  TokensPairDao fromModel(TokensPair tokensPair) {
    return TokensPairDao(
      accessToken: tokensPair.accessToken,
      refreshToken: tokensPair.refreshToken,
      accessTokenExpirationDate: tokensPair.accessTokenExpirationDate,
      refreshTokenExpiretionDate: tokensPair.refreshTokenExpiretionDate,
    );
  }

  TokensPair toModel(TokensPairDao dao) {
    return TokensPair(
      accessToken: dao.accessToken,
      refreshToken: dao.refreshToken,
      accessTokenExpirationDate: dao.accessTokenExpirationDate,
      refreshTokenExpiretionDate: dao.refreshTokenExpiretionDate,
    );
  }
}
