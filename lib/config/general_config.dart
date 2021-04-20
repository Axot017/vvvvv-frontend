class GeneralConfig {
  const GeneralConfig._();

  static const String clientSecret = String.fromEnvironment(
    'CLIENT_SECRET',
    defaultValue: 'secret',
  );
}
