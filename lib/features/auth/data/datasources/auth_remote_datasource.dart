import '../../domain/entities/user_entity.dart';

/// Remote data source for authentication.
/// Replace with actual HTTP/Firebase calls.
abstract class AuthRemoteDataSource {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<bool> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserEntity(id: '1', fullName: 'Brandone Louis', email: email);
  }

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserEntity(id: '2', fullName: fullName, email: email);
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
