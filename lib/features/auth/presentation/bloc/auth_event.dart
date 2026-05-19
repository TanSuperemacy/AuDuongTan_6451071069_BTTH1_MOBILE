import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

class AuthSignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final bool rememberMe;

  AuthSignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthTogglePasswordVisibility extends AuthEvent {}

class AuthToggleRememberMe extends AuthEvent {}

class AuthResetState extends AuthEvent {}
