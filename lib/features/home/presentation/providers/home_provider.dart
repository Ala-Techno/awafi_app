import 'package:flutter/foundation.dart';
import '../../../../core/errors/api_result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';

/// [HomeProvider] - مدير حالة الشاشة الرئيسية والمنتجات (Controller)
/// 
/// المسؤوليات:
/// 1. استقبال أوامر الجلب أو التحديث من واجهة المنتجات (UI).
/// 2. استدعاء عقد البيزنس (HomeRepository) في طبقة الـ Domain.
/// 3. الاحتفاظ بحالة جلب المنتجات (تحميل، نجاح، فشل) وتوفيرها للواجهة.
/// 4. إشعار الواجهة بالتحول بين الحالات لإعادة بناء الودجتس عبر [notifyListeners].
class HomeProvider extends ChangeNotifier {

  // -------------------------------------------------------------
  // 1. Dependency Injection (حقن التبعيات)
  // -------------------------------------------------------------
  /// الاعتماد على العقد المجرد (HomeRepository) وليس التنفيذ المباشر
  final HomeRepository homeRepository;

  HomeProvider({required this.homeRepository});

  // -------------------------------------------------------------
  // 2. Private State Variables (متغيرات الحالة الخاصة)
  // -------------------------------------------------------------
  /// مؤشر يحدد هل يتم تحميل المنتجات من الشبكة الآن
  bool _isLoading = false;

  /// يحمل رسالة الخطأ القادمة عند فشل الطلب
  String? _errorMessage;

  /// يحمل قائمة المنتجات الصافية (ProductEntity) القادمة من الـ Domain
  List<ProductEntity> _products = [];

  // -------------------------------------------------------------
  // 3. Public Getters (قراءة الحالة للواجهة بأمان)
  // -------------------------------------------------------------
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductEntity> get products => _products;

  // -------------------------------------------------------------
  // 4. Controller Action Methods (دوال العمليات)
  // -------------------------------------------------------------

  /// دالة جلب قائمة المنتجات من السيرفر
  Future<void> fetchProducts() async {
    // [مرحلة 1]: بدء الطلب وتعديل الحالة إلى "جاري التحميل"
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // إشعار الواجهة لتمثيل حالة التحميل (Spinner)

    // [مرحلة 2]: استدعاء عقد الـ Domain وانتظار النتيجة المغلّفة بـ ApiResult
    final result = await homeRepository.getProducts();

    // [مرحلة 3]: تقييم النتيجة القادمة من طبقة البيانات عبر الـ Domain
    if (result is Success<List<ProductEntity>>) {
      // حالة النجاح: تخزين قائمة المنتجات
      _products = result.data;
      _errorMessage = null;
    } else if (result is ApiFailure<List<ProductEntity>>) {
      // حالة الفشل: استخراج نص الخطأ المترجم وتفريغ القائمة
      _errorMessage = result.failure.message;
      _products = [];
    }

    // [مرحلة 4]: إغلاق التحميل وإشعار الواجهة بالتحديث النهائي
    _isLoading = false;
    notifyListeners(); // إشعار الواجهة لعرض شبكة المنتجات أو رسالة الخطأ
  }

  /// دالة تنظيف وتصفير بيانات الشاشة
  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _products = [];
    notifyListeners();
  }
}