import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';

abstract class ProfileRepository {
  Future<void> createUser(CreateUserModel model);

  Future<CurrentUser> getCurrentUser();
}
