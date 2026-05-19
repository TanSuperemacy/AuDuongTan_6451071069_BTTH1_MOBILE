import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/strings.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(AppStrings.welcomeBack, style: AppTextStyles.heading1),
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
              ),
              const SizedBox(height: 20),
              _buildLabel(AppStrings.password),
              const SizedBox(height: 8),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildRememberForgotRow(),
              const SizedBox(height: 36),
              _buildPrimaryButton(AppStrings.login, () {}),
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
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.label);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(hintText: hintText),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: AppStrings.passwordHint,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          child: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textHint,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              Icon(
                _rememberMe
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: _rememberMe ? AppColors.accentPurple : AppColors.textHint,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.rememberMe,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary, fontSize: 13),
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

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
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
        child: Text(text, style: AppTextStyles.buttonPrimary),
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

  Widget _buildBottomLink(String prefix, String link, VoidCallback onTap) {
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
