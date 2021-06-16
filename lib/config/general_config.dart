class GeneralConfig {
  const GeneralConfig._();

  static const String clientSecret = String.fromEnvironment(
    'CLIENT_SECRET',
    defaultValue: 'secret',
  );

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://127.0.0.1/',
  );
}
