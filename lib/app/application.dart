import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vvvvv_frontend/routing/main_router.gr.dart';
import 'package:easy_localization/easy_localization.dart';

class Application extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _mainRouter = useMemoized(() => MainRouter());

    return MaterialApp.router(
      routeInformationParser: _mainRouter.defaultRouteParser(),
      routerDelegate: _mainRouter.delegate(),
      title: 'vvvvv',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
