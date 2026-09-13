import '../../domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phone,
    super.avatarUrl,
    super.token,
    super.refreshToken,
    required super.roles,
  });

  /// تحويل من مستند فايرستور أو خريطة عادية إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      token: json['token']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['customer'],
    );
  }

  /// تحويل من Firestore DocumentSnapshot مباشرة
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    return UserModel.fromJson(data, snapshot.id);
  }

  /// تحويل الـ Model إلى خريطة (Map) لحفظها في Firestore أو إرسالها للسيرفر

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'token': token,
      'refreshToken': refreshToken,
      'roles': roles,
    };
  }

  /// تحويل الـ Model إلى Entity خالصة لطبقة الـ Domain
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      avatarUrl: avatarUrl,
      token: token,
      refreshToken: refreshToken,
      roles: roles,
    );
  }
}