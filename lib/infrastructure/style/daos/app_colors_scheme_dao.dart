import 'package:hive/hive.dart';
import 'package:vvvvv_frontend/config/hive_config.dart';

part 'app_colors_scheme_dao.g.dart';

@HiveType(typeId: HiveConfig.appColorsSchemeDaoId)
class AppColorsSchemeDao extends HiveObject {
  @HiveField(0)
  final int backgroundColor;

  AppColorsSchemeDao({required this.backgroundColor});
}
