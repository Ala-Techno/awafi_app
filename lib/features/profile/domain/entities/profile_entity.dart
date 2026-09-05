class ProfileEntity {
  final String id;
  final String username;
  final String email;
  final String phone;

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    this.phone = '',
  });

  ProfileEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
