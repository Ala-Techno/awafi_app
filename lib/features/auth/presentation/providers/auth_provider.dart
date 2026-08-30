import 'package:awafi_app/core/errors/api_result.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// [AuthProvider] - مدير حالة عملية المصادقة (Auth State Controller)
/// 
/// المسؤوليات:
/// 1. استقبال مدخلات المستخدم من الواجهة (UI).
/// 2. استدعاء عقد البيزنس (AuthRepository) في طبقة الـ Domain.
/// 3. الاحتفاظ بحالة العملية (تحميل، نجاح، فشل) وتوفيرها للواجهة.
/// 4. إشعار الواجهة بالتحول بين الحالات لإعادة بناء الودجتس عبر [notifyListeners].
class AuthProvider extends ChangeNotifier {
  
  // -------------------------------------------------------------
  // 1. Dependency Injection (حقن التبعيات)
  // -------------------------------------------------------------
  /// نعتمد على العقد المجرد (Interface) وليس التنفيذ (Impl) 
  /// لضمان فصل الكنترولر عن طبقة الـ Data.
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  // -------------------------------------------------------------
  // 2. Private State Variables (متغيرات الحالة الخاصة)
  // -------------------------------------------------------------
  /// مؤشر يحدد هل التطبيق يقوم بطلب شبكة الآن أم لا
  bool _isLoading = false;

  /// يحمل رسالة الخطأ القادمة من السيرفر أو الشبكة في حال الفشل
  String? _errorMessage;

  /// يحمل كائن المستخدم الصافي (UserEntity) القادم من طبقة Domain عند النجاح
  UserEntity? _user;

  // -------------------------------------------------------------
  // 3. Public Getters (معدات قراءة الحالة للواجهة)
  // -------------------------------------------------------------
  /// تتيح للواجهة قراءة الحالات بأمان دون القدرة على تعديلها يدوياً
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get user => _user;

  // -------------------------------------------------------------
  // 4. Controller Action Methods (دوال العمليات)
  // -------------------------------------------------------------
  
  /// دالة تنفيذ تسجيل الدخول
  /// 
  /// - [email]: البريد الإلكتروني المدخل في الواجهة
  /// - [password]: كلمة المرور المدخلة في الواجهة
  /// - تُرجع [Future<bool>]: `true` في حال النجاح، و `false` في حال الفشل.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // [مرحلة 1]: تجهيز بداية الطلب وتعديل الحالة إلى "جاري التحميل"
    _isLoading = true;
    _errorMessage = null; // تصفير أي خطأ سابق
    notifyListeners(); // إشعارات الواجهة لبدء عرض مؤشر التحميل (Spinner)

    // [مرحلة 2]: استدعاء عقد الـ Domain وانتظار النتيجة المغلّفة بـ ApiResult
    final result = await authRepository.login(
      email: email,
      password: password,
    );

    bool isSuccess = false;

    // [مرحلة 3]: فحص وتقييم النتيجة القادمة من طبقة البيانات عبر الـ Domain
    if (result is Success<UserEntity>) {
      // في حال النجاح: نستخرج البيانات ونخزنها في حالة الكنترولر
      _user = result.data;
      _errorMessage = null;
      isSuccess = true;
    } else if (result is ApiFailure<UserEntity>) {
      // في حال الفشل: نستخرج نص الخطأ ونخزنه في حالة الكنترولر
      _errorMessage = result.failure.message;
      _user = null;
      isSuccess = false;
    }

    // [مرحلة 4]: إغلاق حالة التحميل وإشعار الواجهة بالتحديث النهائي
    _isLoading = false;
    notifyListeners(); // إشعار الواجهة لإخفاء التحميل وعرض النتيجة أو الخطأ

    return isSuccess;
  }

  /// دالة تنظيف وتصفير البيانات (Logout or Clear)
  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _user = null;
    notifyListeners();
  }
}