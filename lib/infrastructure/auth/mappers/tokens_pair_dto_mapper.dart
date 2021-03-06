import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:vvvvv_frontend/utils/current_date_provider.dart';

class TokensPairDtoMapper {
  final CurrentDateProvider _currentDateProvider;

  TokensPairDtoMapper(this._currentDateProvider);

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
