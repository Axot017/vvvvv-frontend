import 'package:hive/hive.dart';
import 'package:vvvvv_frontend/config/hive_configuration.dart';

part 'tokens_pair_dao.g.dart';

@HiveType(typeId: HiveConfiguration.tokensPairDaoId)
class TokensPairDao extends HiveObject {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final String refreshToken;
  @HiveField(2)
  final DateTime accessTokenExpirationDate;
  @HiveField(3)
  final DateTime refreshTokenExpiretionDate;

  TokensPairDao({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpirationDate,
    required this.refreshTokenExpiretionDate,
  });
}
