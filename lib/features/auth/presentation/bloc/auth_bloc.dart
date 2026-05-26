import 'package:flutter/material.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

/// Lightweight BLoC for auth — uses ChangeNotifier (no external BLoC package).
/// Receives use cases via constructor injection (Clean Architecture DI).
class AuthBloc extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase;

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

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => _state = AuthFailure(message: failure.message),
      (user) => _state = AuthLoginSuccess(user: user),
    );
    notifyListeners();
  }

  Future<void> _handleSignUp(AuthSignUpRequested event) async {
    _state = AuthLoading();
    notifyListeners();

    final result = await _signUpUseCase(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => _state = AuthFailure(message: failure.message),
      (user) => _state = AuthSignUpSuccess(user: user),
    );
    notifyListeners();
  }

  Future<void> _handleForgotPassword(
      AuthForgotPasswordRequested event) async {
    _state = AuthLoading();
    notifyListeners();

    final result = await _forgotPasswordUseCase(email: event.email);

    result.fold(
      (failure) => _state = AuthFailure(message: failure.message),
      (_) => _state = AuthForgotPasswordSuccess(email: event.email),
    );
    notifyListeners();
  }
}
