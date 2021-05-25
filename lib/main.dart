import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:vvvvv_frontend/app/application.dart';
import 'package:vvvvv_frontend/app/localization_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(LocalizationWrapper(child: Application()));
}
