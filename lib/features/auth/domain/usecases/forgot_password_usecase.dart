import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for sending a password-reset email.
class ForgotPasswordUseCase {
  final AuthRepository repository;
  const ForgotPasswordUseCase({required this.repository});

  Future<Either<Failure, bool>> call({required String email}) async {
    return repository.forgotPassword(email: email);
  }
}
