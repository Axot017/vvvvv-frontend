import 'package:flutter_test/flutter_test.dart';
import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/create_user_dto_mapper.dart';

import '../../../fallback_values.dart';

void main() {
  late CreateUserDtoMapper mapper;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    mapper = CreateUserDtoMapper();
  });

  test('should map model to dto', () {
    final model = CreateUserModel(
      email: 'email',
      name: 'name',
      password: 'password',
    );

    final result = mapper.fromModel(model);

    expect(result.email, equals(model.email));
    expect(result.name, equals(model.name));
    expect(result.password, equals(model.password));
  });
}
