import 'package:flutter/foundation.dart';

@immutable
class UserEntity {
  final String id;
  final String fullName;
  final String email;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode ^ email.hashCode;

  @override
  String toString() =>
      'UserEntity(id: $id, fullName: $fullName, email: $email)';
}
