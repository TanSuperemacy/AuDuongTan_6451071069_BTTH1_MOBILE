import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user sign-up with full name, email, and password.
/// Delegates to [AuthRepository] — stays Firebase-agnostic.
class SignUpUseCase {
  final AuthRepository repository;
  const SignUpUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
