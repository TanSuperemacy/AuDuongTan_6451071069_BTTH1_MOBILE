import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'successfully_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu.')),
      );
      return;
    }

    _authBloc.add(AuthLoginRequested(
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
        // ── Side-effects on state change ──────────────────────────────────
        final state = _authBloc.state;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (state is AuthLoginSuccess) {
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
                  const Text(AppStrings.welcomeBack,
                      style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.loginSubtitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 36),
                  _buildLabel(AppStrings.email),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppStrings.password),
                  const SizedBox(height: 8),
                  _buildPasswordField(enabled: !isLoading),
                  const SizedBox(height: 16),
                  _buildRememberForgotRow(enabled: !isLoading),
                  const SizedBox(height: 36),
                  _buildPrimaryButton(
                    AppStrings.login,
                    isLoading ? null : _onLoginPressed,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 20),
                  _buildGoogleButton(AppStrings.signInWithGoogle, () {}),
                  const SizedBox(height: 28),
                  _buildBottomLink(
                    AppStrings.dontHaveAccount,
                    AppStrings.signUp,
                    () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
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

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.label);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(hintText: hintText),
    );
  }

  Widget _buildPasswordField({bool enabled = true}) {
    return TextField(
      controller: _passwordController,
      obscureText: !_authBloc.isPasswordVisible,
      enabled: enabled,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: AppStrings.passwordHint,
        suffixIcon: GestureDetector(
          onTap: () => _authBloc.add(AuthTogglePasswordVisibility()),
          child: Icon(
            _authBloc.isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textHint,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow({bool enabled = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: enabled ? () => _authBloc.add(AuthToggleRememberMe()) : null,
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
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
          ),
          child: Text(
            AppStrings.forgotPassword,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
    String text,
    VoidCallback? onPressed, {
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
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
            : Text(text, style: AppTextStyles.buttonPrimary),
      ),
    );
  }

  Widget _buildGoogleButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.g_mobiledata_rounded,
            size: 28, color: AppColors.primaryNavy),
        label: Text(text, style: AppTextStyles.buttonSecondary),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonGoogle,
          foregroundColor: AppColors.primaryNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildBottomLink(
      String prefix, String link, VoidCallback onTap) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(prefix,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          GestureDetector(
            onTap: onTap,
            child: Text(link, style: AppTextStyles.linkOrange),
          ),
        ],
      ),
    );
  }
}

