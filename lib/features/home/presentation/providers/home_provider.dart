import 'package:awafi_app/features/home/data/models/banner_model.dart';
import 'package:awafi_app/features/home/domain/entities/banner_entity.dart';
import 'package:awafi_app/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:awafi_app/features/home/domain/usecases/get_products_use_case.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/api_result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {

  // final GetProductsUseCase getProductsUseCase;
    final GetBannersUseCase getBannersUseCase;
    final GetProductsUseCase getProductsUseCase;

  
 HomeProvider({required this.getBannersUseCase, required this.getProductsUseCase}) {
    // 👈 استدعِ الدوال هنا فور إنشاء الـ Provider
   
  }

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductEntity> _products = [];
  List<BannerEntity> _banners = [];


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductEntity> get products => _products;   
  List<BannerEntity> get banners => _banners;



  Future<void> fetchProducts() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  final result = await getProductsUseCase.call(); 

  result.when(
    success: (products) {
      // تخزين قائمة المنتجات
      _products = products; 
      _errorMessage = null;
    },
    failure: (failure) {
      // عرض رسالة الخطأ
      _errorMessage = failure.message;
      _products = []; 
    },
  );

  _isLoading = false;
  notifyListeners();
}



Future<void> fetchBanners() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  final result = await getBannersUseCase.call(); // استدعاء الـ UseCase

  result.when(
    success: (banners) {
      if (banners.isEmpty) {
        // لو السيرفر ما رجع أي بانر (أو كله معطل)، نضع بانر الصيانة/المحلي افتراضياً
      _banners = [
      BannerModel(id: 'local_1', imageUrl: '', isActive: true, sortOrder: 1, title: 'محلي 1'),
      BannerModel(id: 'local_2', imageUrl: '', isActive: true, sortOrder: 2, title: 'محلي 2'),
    ];
      } else {
        _banners = banners; 
      }
      _errorMessage = null;
    },
    failure: (failure) {
      // حتى لو حصل خطأ في الشبكة، نعرض البانر المحلي بدلاً من كسر التطبيق
      _banners = [
        BannerEntity(
          id: 'local_fallback',
          imageUrl: '',
          isActive: true,
          sortOrder: 0,
          title: 'خطأ اتصال',
        ),
      ];
      _errorMessage = failure.message;
    },
  );

  _isLoading = false;
  notifyListeners();
}





  // -------------------------------------------------------------
  // 4. Controller Action Methods (دوال العمليات)
  // -------------------------------------------------------------

  // /// دالة جلب قائمة المنتجات من السيرفر
  // Future<void> fetchProducts() async {
  //   // [مرحلة 1]: بدء الطلب وتعديل الحالة إلى "جاري التحميل"
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners(); // إشعار الواجهة لتمثيل حالة التحميل (Spinner)

  //   // [مرحلة 2]: استدعاء عقد الـ Domain وانتظار النتيجة المغلّفة بـ ApiResult
  //   final result = await getProductsUseCase.call();
    
  //   // [مرحلة 3]: تقييم النتيجة القادمة من طبقة البيانات عبر الـ Domain
  //   if (result is Success<List<ProductEntity>>) {
  //     // حالة النجاح: تخزين قائمة المنتجات
  //     _products = result.data;
  //     _errorMessage = null;
  //   } else if (result is ApiFailure<List<ProductEntity>>) {
  //     // حالة الفشل: استخراج نص الخطأ المترجم وتفريغ القائمة
  //     _errorMessage = result.failure.message;
  //     _products = [];
  //   }

  //   // [مرحلة 4]: إغلاق التحميل وإشعار الواجهة بالتحديث النهائي
  //   _isLoading = false;
  //   notifyListeners(); // إشعار الواجهة لعرض شبكة المنتجات أو رسالة الخطأ
  // }

  /// دالة تنظيف وتصفير بيانات الشاشة
  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    // _products = [];
    _banners = [];
    notifyListeners();
  }
}