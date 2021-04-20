import 'package:vvvvv_frontend/localization/locale_keys.g.dart';

class Failure {
  final String messageKey;
  final dynamic originalError;
  final List<String> args;

  const Failure(
    this.originalError, {
    this.messageKey = LocaleKeys.error_something_went_wrong,
    this.args = const [],
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure(dynamic originalError)
      : super(
          originalError,
          messageKey: LocaleKeys.error_connection_problem,
        );
}
