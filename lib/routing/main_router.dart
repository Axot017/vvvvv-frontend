import 'package:auto_route/annotations.dart';
import 'package:vvvvv_frontend/presentation/main_page.dart';

@MaterialAutoRouter(routes: [
  AutoRoute(page: MainPage, initial: true),
])
class $MainRouter {}
