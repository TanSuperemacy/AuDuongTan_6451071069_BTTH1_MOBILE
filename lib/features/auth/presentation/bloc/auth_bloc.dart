import 'package:flutter/material.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/entities/user_entity.dart';

/// A lightweight BLoC implementation for auth without external packages.
/// Uses ChangeNotifier + ValueNotifier pattern to mimic BLoC behavior.
class AuthBloc extends ChangeNotifier {
  AuthState _state = AuthInitial();
  bool _isPasswordVisible = false;
  bool _isRememberMe = false;

  AuthState get state => _state;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isRememberMe => _isRememberMe;

  void add(AuthEvent event) {
    if (event is AuthLoginRequested) {
      _handleLogin(event);
    } else if (event is AuthSignUpRequested) {
      _handleSignUp(event);
    } else if (event is AuthForgotPasswordRequested) {
      _handleForgotPassword(event);
    } else if (event is AuthTogglePasswordVisibility) {
      _isPasswordVisible = !_isPasswordVisible;
      notifyListeners();
    } else if (event is AuthToggleRememberMe) {
      _isRememberMe = !_isRememberMe;
      notifyListeners();
    } else if (event is AuthResetState) {
      _state = AuthInitial();
      notifyListeners();
    }
  }

  Future<void> _handleLogin(AuthLoginRequested event) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      final user = UserEntity(
        id: '1',
        fullName: 'Brandone Louis',
        email: event.email,
      );
      _state = AuthLoginSuccess(user: user);
    } catch (e) {
      _state = AuthFailure(message: e.toString());
    }
    notifyListeners();
  }

  Future<void> _handleSignUp(AuthSignUpRequested event) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      final user = UserEntity(
        id: '2',
        fullName: event.fullName,
        email: event.email,
      );
      _state = AuthSignUpSuccess(user: user);
    } catch (e) {
      _state = AuthFailure(message: e.toString());
    }
    notifyListeners();
  }

  Future<void> _handleForgotPassword(
      AuthForgotPasswordRequested event) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _state = AuthForgotPasswordSuccess(email: event.email);
    } catch (e) {
      _state = AuthFailure(message: e.toString());
    }
    notifyListeners();
  }
}
