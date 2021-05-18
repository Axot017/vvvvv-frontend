import 'package:vvvvv_frontend/localization/locale_keys.g.dart';

class Failure implements Exception {
  final String messageKey;
  final dynamic originalError;
  final Map<String, String> args;

  const Failure(
    this.originalError, {
    this.messageKey = LocaleKeys.error_something_went_wrong,
    this.args = const {},
  });
}
