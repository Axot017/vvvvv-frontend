class TokensPair {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpirationDate;
  final DateTime refreshTokenExpiretionDate;

  const TokensPair({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpirationDate,
    required this.refreshTokenExpiretionDate,
  });
}
