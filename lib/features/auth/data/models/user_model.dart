import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
    );
  }

  factory UserModel.fromFakeStoreJson(Map<String, dynamic> json, {required String username}) {
    return UserModel(
      id: json['id']?.toString() ?? '1',
      username: username,
      email: json['email'] ?? '$username@example.com',
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}