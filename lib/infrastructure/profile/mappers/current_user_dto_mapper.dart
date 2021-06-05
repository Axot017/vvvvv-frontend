import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/current_user_dto.dart';

class CurrentUserDtoMapper {
  CurrentUser toModel(CurrentUserDto dto) {
    return CurrentUser(
      name: dto.name,
      avatarUuid: dto.avatarUuid,
      email: dto.email,
    );
  }
}
