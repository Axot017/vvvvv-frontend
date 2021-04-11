import 'package:vvvvv_frontend/domain/auth/model/tokens_pair.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:vvvvv_frontend/utils/current_date_provder.dart';

class TokenPairDtoMapper {
  final CurrentDateProvider _currentDateProvider;

  TokenPairDtoMapper(this._currentDateProvider);

  TokensPair toModel(TokensPairDto dto) {
    final now = _currentDateProvider.getCurrentDate();
    return TokensPair(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      accessTokenExpirationDate: now.add(Duration(
        milliseconds: dto.accessTokenValidFor,
      )),
      refreshTokenExpiretionDate: now.add(Duration(
        milliseconds: dto.refreshTokenValidFor,
      )),
    );
  }
}
