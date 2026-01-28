import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kReleaseMode) return 'https://be.ovladnimechyr.cz/api/v1';

    // iOS simulator + macOS desktop can reach the host via localhost.
    // For Android emulator you typically need: http://10.0.2.2:3000/api/v1
    return 'http://localhost:3000/api/v1';
  }

  static String get testUserEmail {
    if (kReleaseMode) return '';
    return const String.fromEnvironment(
      'TEST_USER_EMAIL',
      defaultValue: 'patient1@example.com',
    );
  }

  static String get testUserPassword {
    if (kReleaseMode) return '';
    return const String.fromEnvironment(
      'TEST_USER_PASSWORD',
      defaultValue: 'test123',
    );
  }
}
