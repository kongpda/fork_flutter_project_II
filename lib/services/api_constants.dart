class ApiConstants {
  static const String baseUrl = 'https://events.iink.dev/api';
  static const String authToken = '$baseUrl/auth/token';
  static const String verifyToken = '$baseUrl/auth/verify';
  static const String authRegister = '$baseUrl/auth/register';
  static const String socialLogin = '$baseUrl/auth/social-login';

  // Event endpoints
  static const String events = '$baseUrl/events';
  static const String categories = '$baseUrl/categories';

  // API token - in production this should be stored securely
  static const String apiToken =
      '98|Epah2slYslCvnWNbbwsjEQipgmR6iEPoS3XKaDkZ26c8be02';
}
