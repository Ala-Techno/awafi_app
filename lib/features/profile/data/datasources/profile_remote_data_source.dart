import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String username,
    required String email,
    required String phone,
  });
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

 @override
Future<ProfileModel> getProfile() async {
  final user = auth.currentUser; // تأكد من اسم متغير الـ auth لديك
  if (user == null) throw Exception('المستخدم غير مسجل دخول');

  // 1. نبحث عن المستند في فايرستور
  final docSnapshot = await firestore.collection('profile').doc(user.uid).get();

  // 2. إذا لم يكن المستند موجوداً (حساب قديم)
  if (!docSnapshot.exists) {
    final defaultProfile = ProfileModel(
      id: user.uid,
      username: user.displayName ?? user.email?.split('@').first ?? 'مستخدم',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
    );
    
    // نقوم بإنشائه تلقائياً في قاعدة البيانات
    await firestore.collection('profile').doc(user.uid).set(defaultProfile.toJson());
    return defaultProfile;
  }

  // 3. إذا كان موجوداً، نجلب بياناته
  return ProfileModel.fromFirestore(docSnapshot);
}
  @override
  Future<ProfileModel> updateProfile({
    required String username,
    required String email,
    required String phone,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('المستخدم غير مسجل دخول');

    final updatedData = {
      'id': user.uid,
      'username': username,
      'email': email,
      'phone': phone,
    };

    // تحديث البيانات في الـ Document الخاص بالمستخدم بناءً على الـ UID
    await firestore.collection('profile').doc(user.uid).update(updatedData);

    return ProfileModel.fromJson(updatedData);
  }
}