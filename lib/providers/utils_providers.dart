import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/utils/current_date_provder.dart';

final currentDateProvider = Provider((_) => CurrentDateProvider());
