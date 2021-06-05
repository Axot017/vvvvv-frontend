import 'package:flutter_test/flutter_test.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/current_user_dto.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/current_user_dto_mapper.dart';

import '../../../fallback_values.dart';

void main() {
  late CurrentUserDtoMapper mapper;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    mapper = CurrentUserDtoMapper();
  });

  test('should map dto to model', () {
    final dto = CurrentUserDto(
      name: 'testName',
      email: 'testEmail',
      avatarUuid: 'testUUID',
    );

    final result = mapper.toModel(dto);

    expect(result.name, equals(dto.name));
    expect(result.email, equals(dto.email));
    expect(result.avatarUuid, equals(dto.avatarUuid));
  });
}
