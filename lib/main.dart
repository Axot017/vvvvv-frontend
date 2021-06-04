import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/app/application.dart';
import 'package:vvvvv_frontend/app/localization_wrapper.dart';
import 'package:vvvvv_frontend/config/hive_config.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/style/daos/app_colors_scheme_dao.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppColorsSchemeDaoAdapter());
  Hive.registerAdapter(TokensPairDaoAdapter());
  await Hive.openBox<AppColorsSchemeDao>(HiveConfig.appColorsBoxName);
  await Hive.openBox<TokensPairDao>(HiveConfig.tokensPairBoxName);
  runApp(ProviderScope(
    child: LocalizationWrapper(
      child: Application(),
    ),
  ));
}
