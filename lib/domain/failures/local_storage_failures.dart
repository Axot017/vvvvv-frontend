import 'package:vvvvv_frontend/domain/failures/failure.dart';

class LocalStorageReadFailure extends Failure {
  LocalStorageReadFailure(dynamic originalError) : super(originalError);
}
