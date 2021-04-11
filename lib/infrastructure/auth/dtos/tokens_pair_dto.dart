import 'package:json_annotation/json_annotation.dart';

part 'tokens_pair_dto.g.dart';

@JsonSerializable(createToJson: false)
class TokensPairDto {
  final String accessToken;
  final String refreshToken;
  final int accessTokenValidFor;
  final int refreshTokenValidFor;

  const TokensPairDto({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenValidFor,
    required this.refreshTokenValidFor,
  });

  factory TokensPairDto.fromJson(Map<String, dynamic> json) =>
      _$TokenPairDtoFromJson(json);
}
