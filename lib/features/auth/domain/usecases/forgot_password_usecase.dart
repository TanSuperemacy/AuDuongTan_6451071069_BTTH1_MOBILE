/// Use case for resetting user password via email.
class ForgotPasswordUseCase {
  Future<bool> call({required String email}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Placeholder: Replace with actual repository call
    return true;
  }
}
