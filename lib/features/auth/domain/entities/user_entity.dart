/// [UserEntity] — Pure Domain object representing an authenticated user.
/// No dependencies on Flutter, Dio, or any external library.
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? token;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  // ═══════════════════════════════════════════════════════════════════
  //  PRODUCTION SERVER — Extended UserEntity fields (Commented)
  // ═══════════════════════════════════════════════════════════════════
  // final String firstName;
  // final String lastName;
  // final String phone;
  // final String? avatarUrl;
  // final String? refreshToken;
  // final List<String> roles;         // e.g., ['customer', 'admin']
  // final ShippingAddress? defaultAddress;
  // ═══════════════════════════════════════════════════════════════════
}