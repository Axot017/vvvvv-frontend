import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/providers/style_providers.dart';
import 'package:vvvvv_frontend/routing/main_router.gr.dart';
import 'package:easy_localization/easy_localization.dart';

class Application extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final mainRouter = useMemoized(() => MainRouter());
    final appColors = useProvider(appColorsProvider);

    return MaterialApp.router(
      theme: ThemeData(scaffoldBackgroundColor: appColors.background),
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(),
      title: 'vvvvv',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
