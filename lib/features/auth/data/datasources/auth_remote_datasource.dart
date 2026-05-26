import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Contract for the remote auth data source.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<bool> forgotPassword({required String email});
}

/// Firebase implementation — talks to Firebase Auth + Firestore.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Login ───────────────────────────────────────────────────────────────
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;
      // Fetch extra profile info from Firestore
      final doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, user.uid);
      }
      // Fallback: build from FirebaseUser if Firestore doc missing
      return UserModel(
        id: user.uid,
        fullName: user.displayName ?? '',
        email: user.email ?? email,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e));
    } catch (e) {
      throw AuthException(message: 'Đăng nhập thất bại: ${e.toString()}');
    }
  }

  // ─── Sign Up ─────────────────────────────────────────────────────────────
  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      // Update Firebase Auth display name
      await user.updateDisplayName(fullName);

      // Save user profile to Firestore
      final model = UserModel(
        id: user.uid,
        fullName: fullName,
        email: user.email ?? email,
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(model.toMap());

      return model;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e));
    } catch (e) {
      throw AuthException(message: 'Đăng ký thất bại: ${e.toString()}');
    }
  }

  // ─── Forgot Password ─────────────────────────────────────────────────────
  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e));
    } catch (e) {
      throw AuthException(message: 'Gửi email thất bại: ${e.toString()}');
    }
  }

  // ─── Helper: Map Firebase error codes → Vietnamese messages ──────────────
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này.';
      case 'wrong-password':
        return 'Mật khẩu không đúng. Vui lòng thử lại.';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng. Vui lòng đăng nhập.';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Cần ít nhất 6 ký tự.';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa.';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng đợi rồi thử lại.';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không chính xác.';
      default:
        return e.message ?? 'Đã có lỗi xảy ra. Vui lòng thử lại.';
    }
  }
}
