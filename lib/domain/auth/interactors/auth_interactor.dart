import 'package:vvvvv_frontend/domain/auth/repositories/auth_repository.dart';

class AuthInteractor {
  final AuthRepository _authInteractor;

  AuthInteractor(this._authInteractor);

  Future<void> logout() async {}
}
