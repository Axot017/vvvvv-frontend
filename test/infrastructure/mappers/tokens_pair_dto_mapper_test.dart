import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/utils/current_date_provder.dart';

class MockedCurrentDateProvider extends Mock implements CurrentDateProvider {}

void main() {
  late MockedCurrentDateProvider mockedCurrentDateProvider;
  late TokensPairDtoMapper tokenPairDtoMapper;

  setUp(() {
    mockedCurrentDateProvider = MockedCurrentDateProvider();
    tokenPairDtoMapper = TokensPairDtoMapper(mockedCurrentDateProvider);
  });

  test('should convert dto to model', () {
    when(() => mockedCurrentDateProvider.getCurrentDate())
        .thenReturn(DateTime.now());

    final dto = TokensPairDto(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenValidFor: 111,
      refreshTokenValidFor: 111,
    );

    final result = tokenPairDtoMapper.toModel(dto);

    expect(result.accessToken, equals(dto.accessToken));
    expect(result.refreshToken, equals(dto.refreshToken));
  });

  test('should convert time in miliseconds to datetime object', () {
    final accessMilis = const Duration(minutes: 15).inMilliseconds;
    final refreshMilis = const Duration(days: 7).inMilliseconds;
    final initialDate = DateTime(2020);
    when(() => mockedCurrentDateProvider.getCurrentDate())
        .thenReturn(initialDate);

    final dto = TokensPairDto(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
      accessTokenValidFor: accessMilis,
      refreshTokenValidFor: refreshMilis,
    );

    final result = tokenPairDtoMapper.toModel(dto);

    final accessTokenExpectedDate = DateTime(2020, 1, 1, 0, 15);
    final refreshTokenExpectedDate = DateTime(2020, 1, 8);
    expect(result.accessTokenExpirationDate, equals(accessTokenExpectedDate));
    expect(result.refreshTokenExpiretionDate, equals(refreshTokenExpectedDate));
  });
}
