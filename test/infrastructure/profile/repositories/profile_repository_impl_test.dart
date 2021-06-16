import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';
import 'package:vvvvv_frontend/domain/profile/repositories/profile_repository.dart';
import 'package:vvvvv_frontend/infrastructure/networking/decorators/with_dio_error_mapper_decorator.dart';
import 'package:vvvvv_frontend/infrastructure/profile/data_sources/profile_remote_data_source.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/create_user_dto.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/current_user_dto.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/create_user_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/profile/mappers/current_user_dto_mapper.dart';
import 'package:vvvvv_frontend/infrastructure/profile/repositories/profile_repository_impl.dart';

import '../../../fallback_values.dart';

class MockedProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockedCurrentUserDtoMapper extends Mock implements CurrentUserDtoMapper {}

class MockedWithDioErrorMapperDecorator extends Mock
    implements WithDioErrorMapperDecorator {}

class MockedCreateUserDtoMapper extends Mock implements CreateUserDtoMapper {}

void main() {
  late ProfileRemoteDataSource profileRemoteDataSource;
  late CurrentUserDtoMapper currentUserDtoMapper;
  late WithDioErrorMapperDecorator withDioErrorMapperDecorator;
  late CreateUserDtoMapper createUserDtoMapper;
  late ProfileRepository profileRepository;

  setUpAll(() {
    registerAllFallbackValues();
  });

  setUp(() {
    profileRemoteDataSource = MockedProfileRemoteDataSource();
    currentUserDtoMapper = MockedCurrentUserDtoMapper();
    withDioErrorMapperDecorator = MockedWithDioErrorMapperDecorator();
    createUserDtoMapper = MockedCreateUserDtoMapper();
    profileRepository = ProfileRepositoryImpl(
      profileRemoteDataSource,
      currentUserDtoMapper,
      withDioErrorMapperDecorator,
      createUserDtoMapper,
    );

    when(() => withDioErrorMapperDecorator(any()))
        .thenAnswer((invocation) => invocation.positionalArguments.first());
  });

  group('getCurrentUser', () {
    test('should call backend with error mapper decorator and map response',
        () async {
      final dto = CurrentUserDto(
        name: 'name',
        email: 'email',
        avatarUuid: 'avatarUuid',
      );
      final model = CurrentUser(
        name: 'name',
        email: 'email',
        avatarUuid: 'avatarUuid',
      );
      when(() => profileRemoteDataSource.getCurrentUser())
          .thenAnswer((_) => Future.value(dto));
      when(() => currentUserDtoMapper.toModel(any())).thenReturn(model);

      final result = await profileRepository.getCurrentUser();

      expect(result, equals(model));
      verify(() => profileRemoteDataSource.getCurrentUser()).called(1);
      verify(() => currentUserDtoMapper.toModel(dto)).called(1);
      verify(() => withDioErrorMapperDecorator(any())).called(1);
    });

    test('should throw mapped error', () async {
      final dto = CurrentUserDto(
        name: 'name',
        email: 'email',
        avatarUuid: 'avatarUuid',
      );
      final exception = Exception('');
      when(() => profileRemoteDataSource.getCurrentUser())
          .thenAnswer((_) async {
        throw exception;
      });

      try {
        await profileRepository.getCurrentUser();
      } catch (e) {
        expect(e, equals(exception));
      }

      verify(() => profileRemoteDataSource.getCurrentUser()).called(1);
      verifyNever(() => currentUserDtoMapper.toModel(dto));
      verify(() => withDioErrorMapperDecorator(any())).called(1);
    });
  });

  group('createUser', () {
    test('should use mapper and call backend', () async {
      final dto = CreateUserDto(
        email: 'email',
        name: 'name',
        password: 'password',
      );
      final model = CreateUserModel(
        email: 'email',
        name: 'name',
        password: 'password',
      );
      when(() => profileRemoteDataSource.createUser(any()))
          .thenAnswer((_) => Future.value());
      when(() => createUserDtoMapper.fromModel(any())).thenReturn(dto);

      await profileRepository.createUser(model);

      verify(() => profileRemoteDataSource.createUser(dto)).called(1);
      verify(() => createUserDtoMapper.fromModel(model)).called(1);
      verify(() => withDioErrorMapperDecorator(any())).called(1);
    });

    test('should throw mapped error', () async {
      final dto = CreateUserDto(
        email: 'email',
        name: 'name',
        password: 'password',
      );
      final model = CreateUserModel(
        email: 'email',
        name: 'name',
        password: 'password',
      );
      final exception = Exception('');
      when(() => profileRemoteDataSource.createUser(any()))
          .thenAnswer((_) async {
        throw exception;
      });
      when(() => createUserDtoMapper.fromModel(any())).thenReturn(dto);

      try {
        await profileRepository.createUser(model);
      } catch (e) {
        expect(e, equals(exception));
      }

      verify(() => profileRemoteDataSource.createUser(dto)).called(1);
      verify(() => createUserDtoMapper.fromModel(model)).called(1);
      verify(() => withDioErrorMapperDecorator(any())).called(1);
    });
  });
}
