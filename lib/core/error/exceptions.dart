/// Exception thrown by the data/datasource layer.
/// Repositories catch these and convert to [Failure] objects.

class AuthException implements Exception {
  final String message;
  const AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}
