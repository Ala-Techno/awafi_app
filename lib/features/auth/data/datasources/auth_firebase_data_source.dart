import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awafi_app/core/errors/exceptions.dart';
import 'package:awafi_app/features/auth/data/models/user_model.dart'; 
import 'package:awafi_app/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthFirebaseDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  /// دالة مركزية للتعامل مع أخطاء فايربيس ومنع تكرار الـ try-catch
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'حدث خطأ في المصادقة');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    return _guard(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      // 1. تسجيل الدخول عبر Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
   
      final uid = userCredential.user?.uid;
      // جلب وطباعة التوكن الحقيقي من الـ user
      final token = await userCredential.user?.getIdToken();
   
      if (uid == null) {
        throw const ServerException(message: 'فشل العثور على معرف المستخدم');
      }

      // 2. جلب بيانات المستخدم من Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw const ServerException(message: 'بيانات المستخدم غير موجودة في قاعدة البيانات');
      }

      final userData = userDoc.data()!;
      return UserModel.fromJson(userData, uid);
    });
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    return _guard(() async {
      // 1. إنشاء الحساب في Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw const ServerException(message: 'فشل إنشاء حساب المستخدم');
      }

      // 2. تجهيز بيانات المستخدم لتخزينها في Firestore (كولكشن users)
      final userMap = {
        'id': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'avatarUrl': '',
        'roles': ['customer'],
      };

      // 3. حفظ المستند في مجموعة users بنفس الـ UID كمعرف للمستند
      await _firestore.collection('users').doc(uid).set(userMap);

      // 4. 🔥 إنشاء أو تحديث مستند البروفايل في كولكشن profile لضمان حفظ رقم الهاتف هناك أيضاً
      final profileMap = {
        'id': uid,
        'username': '$firstName $lastName',
        'email': email,
        'phone': phone,
      };
      await _firestore.collection('profile').doc(uid).set(profileMap);

      return UserModel.fromJson(userMap, uid);
    });
  }
}