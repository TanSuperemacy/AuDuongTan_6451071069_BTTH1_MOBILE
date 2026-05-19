import '../entities/user_entity.dart';

/// Use case for user sign-up with full name, email, and password.
class SignUpUseCase {
  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Placeholder: Replace with actual repository call
    return UserEntity(
      id: '2',
      fullName: fullName,
      email: email,
    );
  }
}
