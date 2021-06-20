import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:vvvvv_frontend/utils/current_date_provider.dart';

final currentDateProvider = Provider<CurrentDateProvider>((ref) {
  return CurrentDateProvider();
});

final loggerProvider = Provider<Logger>((ref) {
  return Logger(
    level: Level.info,
    printer: PrettyPrinter(),
  );
});
