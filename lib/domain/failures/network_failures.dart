import 'package:vvvvv_frontend/domain/failures/failure.dart';
import 'package:vvvvv_frontend/localization/locale_keys.g.dart';

class UnknownRequestFailure extends Failure {
  const UnknownRequestFailure(dynamic originalError) : super(originalError);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(dynamic originalError)
      : super(
          originalError,
          messageKey: LocaleKeys.error_connection_problem,
        );
}

class RequestFailure extends Failure {
  const RequestFailure(
    dynamic originalError, {
    String messageKey = LocaleKeys.error_something_went_wrong,
    Map<String, String> args = const {},
  }) : super(
          originalError,
          messageKey: messageKey,
          args: args,
        );
}

class ServerFailure extends Failure {
  const ServerFailure(
    dynamic originalError, {
    String messageKey = LocaleKeys.error_service_inactive,
    Map<String, String> args = const {},
  }) : super(
          originalError,
          messageKey: messageKey,
          args: args,
        );
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(dynamic originalError)
      : super(
          originalError,
          messageKey: LocaleKeys.error_unauthenticated,
        );
}
