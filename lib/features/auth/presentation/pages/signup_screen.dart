import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';
import 'login_screen.dart';
import 'successfully_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
      );
      return;
    }

    _authBloc.add(AuthSignUpRequested(
      fullName: fullName,
      email: email,
      password: password,
      rememberMe: _authBloc.isRememberMe,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authBloc,
      builder: (context, _) {
        final state = _authBloc.state;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (state is AuthSignUpSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SuccessfullyScreen()),
            );
            _authBloc.add(AuthResetState());
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
            _authBloc.add(AuthResetState());
          }
        });

        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      AppStrings.appName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(AppStrings.createAccount,
                      style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.signUpSubtitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 36),
                  // Full name
                  Text(AppStrings.fullName, style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _fullNameController,
                    enabled: !isLoading,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: AppStrings.fullNameHint,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email
                  Text(AppStrings.email, style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: AppStrings.emailHint,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password
                  Text(AppStrings.password, style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_authBloc.isPasswordVisible,
                    enabled: !isLoading,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: AppStrings.passwordHint,
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            _authBloc.add(AuthTogglePasswordVisibility()),
                        child: Icon(
                          _authBloc.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Remember me
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => _authBloc.add(AuthToggleRememberMe()),
                    child: Row(
                      children: [
                        Icon(
                          _authBloc.isRememberMe
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: _authBloc.isRememberMe
                              ? AppColors.accentPurple
                              : AppColors.textHint,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.rememberMe,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // SIGN UP Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSignUpPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        foregroundColor: AppColors.textWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(AppStrings.signUpButton,
                              style: AppTextStyles.buttonPrimary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // SIGN UP WITH GOOGLE
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata_rounded,
                          size: 28, color: AppColors.primaryNavy),
                      label: Text(AppStrings.signUpWithGoogle,
                          style: AppTextStyles.buttonSecondary),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGoogle,
                        foregroundColor: AppColors.primaryNavy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Sign in link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          ),
                          child: Text(AppStrings.signIn,
                              style: AppTextStyles.linkOrange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

