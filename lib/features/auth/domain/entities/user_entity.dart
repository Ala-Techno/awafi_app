/// [UserEntity] — Pure Domain object representing an authenticated user.
/// No dependencies on Flutter, Dio, or any external library.
class UserEntity {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? avatarUrl;
  final String? token;
  final String? refreshToken;
  final List<String> roles; // e.g., ['customer', 'admin']

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.avatarUrl,
    this.token,
    this.refreshToken,
    this.roles = const ['customer'],
  });
}