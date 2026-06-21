class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://supabase.justiciadministrativa.com',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzgwMTE1NTkyLCJleHAiOjIwOTU0NzU1OTJ9.2IQuH_e284MXPeXcRpqGdSV6D3ULtSlshW_5kohcWRM',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const String appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const String appRelease = String.fromEnvironment(
    'APP_RELEASE',
    defaultValue: 'justicia-site@1.0.0',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// The URL that Supabase embeds in password-reset emails as the `redirectTo`
  /// parameter. After the user clicks the link, the browser lands on this URL
  /// with `#access_token=...&type=recovery` in the fragment, which
  /// `supabase_flutter` auto-detects and fires [AuthChangeEvent.passwordRecovery].
  ///
  /// Override at build time with `--dart-define=PASSWORD_RESET_REDIRECT=<url>`.
  static const String passwordResetRedirect = String.fromEnvironment(
    'PASSWORD_RESET_REDIRECT',
    defaultValue: 'https://justiciadministrativa.com/reset-password',
  );

  static const String _sentryTracesSampleRateRaw = String.fromEnvironment(
    'SENTRY_TRACES_SAMPLE_RATE',
    defaultValue: '0.1',
  );

  static const String _sentryProfilesSampleRateRaw = String.fromEnvironment(
    'SENTRY_PROFILES_SAMPLE_RATE',
    defaultValue: '0.0',
  );

  static double get sentryTracesSampleRate {
    final parsed = double.tryParse(_sentryTracesSampleRateRaw);
    if (parsed == null) return 0.1;
    return parsed.clamp(0.0, 1.0).toDouble();
  }

  static double get sentryProfilesSampleRate {
    final parsed = double.tryParse(_sentryProfilesSampleRateRaw);
    if (parsed == null) return 0.0;
    return parsed.clamp(0.0, 1.0).toDouble();
  }

  static bool get isSentryEnabled => sentryDsn.trim().isNotEmpty;
}
