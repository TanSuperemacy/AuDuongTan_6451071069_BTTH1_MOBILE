import '../../domain/entities/user_entity.dart';

/// Data-layer model — bridges Firestore documents ↔ Domain entities.
/// The domain layer never knows about this class.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// Create from a Firestore document map.
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      id: uid,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  /// Serialize to Firestore document map.
  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      };

  /// Convert domain entity to model (useful when building from Firebase User).
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
    );
  }
}
