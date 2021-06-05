import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';

abstract class ProfileRepository {
  Future<void> createUser();

  Future<CurrentUser> getCurrentUser();
}
