import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/domain/style/models/app_colors_scheme.dart';
import 'package:vvvvv_frontend/providers/style_providers.dart';

class MainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = useProvider(appColorsProvider.notifier);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            appColors.changeColorsScheme(AppColorsScheme.light());
          },
          child: const Text('test'),
        ),
      ),
    );
  }
}
