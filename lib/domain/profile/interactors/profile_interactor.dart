import 'package:vvvvv_frontend/domain/profile/models/create_user_model.dart';
import 'package:vvvvv_frontend/domain/profile/models/current_user.dart';
import 'package:vvvvv_frontend/domain/profile/repositories/profile_repository.dart';

class ProfileInteractor {
  final ProfileRepository _profileRepository;

  ProfileInteractor(this._profileRepository);

  Future<CurrentUser> getCurrentUser() {
    return _profileRepository.getCurrentUser();
  }

  Future<void> createUser(CreateUserModel model) async {
    return _profileRepository.createUser(model);
  }
}
