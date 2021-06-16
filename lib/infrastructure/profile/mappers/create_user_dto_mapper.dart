import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/create_user_dto.dart';

class CreateUserDtoMapper {
  CreateUserDto fromModel(CreateUserModel model) {
    return CreateUserDto(
      email: model.email,
      name: model.name,
      password: model.password,
    );
  }
}
