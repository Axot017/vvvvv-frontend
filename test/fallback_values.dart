import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/auth/models/tokens_pair.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';

void registerAllFallbackValues() {
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
  registerFallbackValue(RequestOptions(
    path: '',
  ));
  registerFallbackValue(DioError(
    requestOptions: RequestOptions(path: ''),
  ));
  registerFallbackValue(AppColorsScheme(backgroundColor: 0xFFFF9000));
  registerFallbackValue(AppColorsSchemeDao(backgroundColor: 0xFFFF9000));
}
