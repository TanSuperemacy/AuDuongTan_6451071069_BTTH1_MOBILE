import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final UserEntity user;
  AuthLoginSuccess({required this.user});
}

class AuthSignUpSuccess extends AuthState {
  final UserEntity user;
  AuthSignUpSuccess({required this.user});
}

class AuthForgotPasswordSuccess extends AuthState {
  final String email;
  AuthForgotPasswordSuccess({required this.email});
}

class AuthPasswordResetSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}
