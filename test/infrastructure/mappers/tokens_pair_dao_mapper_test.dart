import 'package:flutter_test/flutter_test.dart';
import 'package:vvvvv_frontend/domain/auth/model/tokens_pair.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dao_mapper.dart';

void main() {
  late TokensPairDaoMapper mapper;

  setUp(() {
    mapper = TokensPairDaoMapper();
  });

  test('should map model to dao', () {
    final testModel = TokensPair(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2021),
      refreshTokenExpiretionDate: DateTime(2021),
    );

    final result = mapper.fromModel(testModel);

    expect(result.accessToken, testModel.accessToken);
    expect(result.refreshToken, testModel.refreshToken);
    expect(
      result.accessTokenExpirationDate,
      testModel.accessTokenExpirationDate,
    );
    expect(
      result.refreshTokenExpiretionDate,
      testModel.refreshTokenExpiretionDate,
    );
  });

  test('should map dao to model', () {
    final testDao = TokensPairDao(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenExpirationDate: DateTime(2021),
      refreshTokenExpiretionDate: DateTime(2021),
    );

    final result = mapper.toModel(testDao);

    expect(result.accessToken, testDao.accessToken);
    expect(result.refreshToken, testDao.refreshToken);
    expect(
      result.accessTokenExpirationDate,
      testDao.accessTokenExpirationDate,
    );
    expect(
      result.refreshTokenExpiretionDate,
      testDao.refreshTokenExpiretionDate,
    );
  });
}
