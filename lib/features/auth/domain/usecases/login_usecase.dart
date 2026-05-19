import '../entities/user_entity.dart';

/// Use case for user login with email and password.
class LoginUseCase {
  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Placeholder: Replace with actual repository call
    return UserEntity(
      id: '1',
      fullName: 'Brandone Louis',
      email: email,
    );
  }
}
