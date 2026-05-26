import 'package:flutter/foundation.dart';

/// Base failure class for Clean Architecture error handling.
@immutable
abstract class Failure {
  final String message;
  const Failure({required this.message});
}

/// Firebase Authentication related failures
class AuthFailureEntity extends Failure {
  const AuthFailureEntity({required super.message});
}

/// Network / connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Unknown / unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
