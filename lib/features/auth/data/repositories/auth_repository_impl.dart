import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';

/// Repository implementation for authentication operations.
class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(email: email, password: password);
  }

  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  Future<bool> forgotPassword({required String email}) async {
    return await remoteDataSource.forgotPassword(email: email);
  }
}
