import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationWrapper extends StatelessWidget {
  final Widget child;

  const LocalizationWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('pl')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pl'),
      child: child,
    );
  }
}
