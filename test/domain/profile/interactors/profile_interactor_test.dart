import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/profile/interactors/profile_interactor.dart';
import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';
import 'package:vvvvv_frontend/domain/profile/repositories/profile_repository.dart';

import '../../../fallback_values.dart';

class MockedProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockedProfileRepository profileRepository;
  late ProfileInteractor interactor;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    profileRepository = MockedProfileRepository();
    interactor = ProfileInteractor(profileRepository);
  });

  test('should use repository to get current user', () async {
    final currentUser = CurrentUser(
      name: 'name',
      avatarUuid: 'avatarUuid',
      email: 'email',
    );
    when(() => profileRepository.getCurrentUser())
        .thenAnswer((_) => Future.value(currentUser));

    final result = await interactor.getCurrentUser();

    expect(result, equals(currentUser));
    verify(() => profileRepository.getCurrentUser()).called(1);
  });

  test('should use repository to create user', () async {
    final model = CreateUserModel(
      name: 'name',
      password: 'password',
      email: 'email',
    );
    when(() => profileRepository.createUser(any()))
        .thenAnswer((_) => Future.value());

    await interactor.createUser(model);

    verify(() => profileRepository.createUser(model)).called(1);
  });
}
