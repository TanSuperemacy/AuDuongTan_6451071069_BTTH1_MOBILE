import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login with email and password.
/// Delegates to [AuthRepository] — stays Firebase-agnostic.
class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return repository.login(email: email, password: password);
  }
}
