import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract contract for auth operations — lives in the Domain layer.
/// The Data layer provides the concrete implementation.
abstract class AuthRepository {
  /// Returns [UserEntity] on success, [Failure] on error.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Returns [UserEntity] on success, [Failure] on error.
  Future<Either<Failure, UserEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  /// Sends a password-reset email. Returns [true] on success.
  Future<Either<Failure, bool>> forgotPassword({required String email});
}
