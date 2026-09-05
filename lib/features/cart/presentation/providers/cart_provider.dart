import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

/// [CartController] - مدير حالة السلة (Controller / Provider)
///
/// المسؤوليات:
/// 1. استقبال أوامر الجلب، الإضافة، التعديل، والحذف من واجهة السلة (UI).
/// 2. استدعاء عقد البيزنس (CartRepository) في طبقة الـ Domain.
/// 3. إدارة حالات الطلب (تحميل، نجاح، فشل) بأسلوب آمن ودقيق.
/// 4. إشعار الواجهة بالتحديثات عبر [notifyListeners] في دورة حياة صريحة وموحدة.
class CartController extends ChangeNotifier {
  // -------------------------------------------------------------
  // 1. Dependency Injection (حقن التبعيات)
  // -------------------------------------------------------------
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  // -------------------------------------------------------------
  // 2. Private State Variables (متغيرات الحالة الخاصة)
  // -------------------------------------------------------------
  /// مؤشر يحدد هل يتم تنفيذ عملية شبكة حالياً
  bool _isLoading = false;

  /// يحمل نص الخطأ المترجم عند فشل الطلب (Nullable لسهولة الفحص)
  String? _errorMessage;

  /// يحمل قائمة عناصر السلة المصفاة (CartItemEntity) القادمة من الـ Domain
  List<CartItemEntity> _cartItems = [];

  // -------------------------------------------------------------
  // 3. Public Getters (قراءة الحالة للواجهة بأمان)
  // -------------------------------------------------------------
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CartItemEntity> get cartItems => _cartItems;

  // داخل كلاس CartController

/// إجمالي مبلغ السلة بالكامل
double get totalPrice => _cartItems.fold(
      0.0,
      (sum, item) => sum + item.itemTotalPrice,
    );

/// إجمالي عدد القطع في السلة
int get totalItemCount => _cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

  // -------------------------------------------------------------
  // 4. Controller Action Methods (دوال العمليات)
  // -------------------------------------------------------------

  /// 1. دالة جلب عناصر السلة (عملية قراءة - ترجع void)
  // Future<void> fetchCartItems(int userId) async {
  //   // [مرحلة 1]: بدء الطلب وإشعار الواجهة بحالة التحميل
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   // [مرحلة 2]: استدعاء عقد الـ Domain وانتظار النتيجة
  //   final result = await cartRepository.getCartItems(userId);

  //   // [مرحلة 3]: تقييم النتيجة
  //   if (result is Success<List<CartItemEntity>>) {
  //     _cartItems = result.data;
  //     _errorMessage = null;
  //   } else if (result is ApiFailure<List<CartItemEntity>>) {
  //     _errorMessage = result.failure.message;
  //     _cartItems = [];
  //   }

  //   // [مرحلة 4]: إنهاء التحميل وإشعار الواجهة بالنتيجة النهائية
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // /// 2. دالة إضافة منتج للسلة (Action يرجع bool للـ UI)
  // Future<bool> addToCart({
  //   required int userId,
  //   required int productId,
  //   required int quantity,
  // }) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   final result = await cartRepository.addToCart(userId, productId, quantity);

  //   bool isSuccess = false;

  //   if (result is Success<List<CartItemEntity>>) {
  //     _cartItems = result.data;
  //     _errorMessage = null;
  //     isSuccess = true;
  //   } else if (result is ApiFailure<List<CartItemEntity>>) {
  //     _errorMessage = result.failure.message;
  //     isSuccess = false;
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  //   return isSuccess;
  // }



                // تخزين محلي مؤقت
  // ________________________________
  // ________________________________


/// 1. دالة إضافة منتج للسلة (تأخذ كائن ProductEntity كاملاً لضمان عدم ضياع البيانات)
Future<bool> addToCart({
  required int userId,
  required ProductEntity product,
  required int quantity,
}) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  // فحص ما إذا كان المنتج موجوداً مسبقاً في القائمة المحلية
  final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);

  if (existingIndex >= 0) {
    // تحديث الكمية محلياً
    final existingItem = _cartItems[existingIndex];
    _cartItems[existingIndex] = CartItemEntity(
      id: existingItem.id,
      product: product,
      quantity: existingItem.quantity + quantity,
    );
  } else {
    // إضافة المنتج الجديد بكامل بياناته إلى القائمة المحلية
    _cartItems.add(
      CartItemEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        product: product,
        quantity: quantity,
      ),
    );
  }

  // إرسال طلب خلفي للـ Repository (للحفاظ على الـ Flow الخاص بالـ Clean Architecture)
  await cartRepository.addToCart(userId, product.id, quantity);

  _isLoading = false;
  notifyListeners();
  return true;
}

/// 2. دالة جلب عناصر السلة (إذا كانت القائمة المحلية فارغة فقط تجلب البيانات الأساسية)
Future<void> fetchCartItems(int userId) async {
  // إذا كان لدى المستخدم عناصر أضيفت محلياً، لا نمسحها ببيانات السيرفر الوهمية
  if (_cartItems.isNotEmpty) return;

  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  final result = await cartRepository.getCartItems(userId);

  if (result is Success<List<CartItemEntity>>) {
    _cartItems = result.data;
    _errorMessage = null;
  } else if (result is ApiFailure<List<CartItemEntity>>) {
    _errorMessage = result.failure.message;
  }

  _isLoading = false;
  notifyListeners();
}

/// 3. دالة حذف عنصر محدد من القائمة المحلية
Future<bool> removeFromCart(int cartItemId) async {
  _cartItems.removeWhere((item) => item.id == cartItemId);
  notifyListeners();
  
  // إرسال طلب الحذف للسيرفر في الخلفية
  cartRepository.removeFromCart(cartItemId);
  return true;
}


/// تعديل كمية منتج محلياً
void updateQuantityLocal({required int cartItemId, required int newQuantity}) {
  if (newQuantity <= 0) return;
  final index = _cartItems.indexWhere((item) => item.id == cartItemId);
  if (index >= 0) {
    _cartItems[index] = CartItemEntity(
      id: _cartItems[index].id,
      product: _cartItems[index].product,
      quantity: newQuantity,
    );
    notifyListeners();
  }
}
// _________________________
// _________________________


  /// 3. دالة تعديل كمية منتج (Action يرجع bool للـ UI)
  // Future<bool> updateQuantity({
  //   required int cartId,
  //   required int productId,
  //   required int newQuantity,
  // }) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   final result = await cartRepository.updateQuantity(cartId, productId, newQuantity);

  //   bool isSuccess = false;

  //   if (result is Success<List<CartItemEntity>>) {
  //     _cartItems = result.data;
  //     _errorMessage = null;
  //     isSuccess = true;
  //   } else if (result is ApiFailure<List<CartItemEntity>>) {
  //     _errorMessage = result.failure.message;
  //     isSuccess = false;
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  //   return isSuccess;
  // }

  /// 4. دالة حذف عنصر من السلة (Action يرجع bool للـ UI)
  // Future<bool> removeFromCart(int cartId) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   final result = await cartRepository.removeFromCart(cartId);

  //   bool isSuccess = false;

  //   if (result is Success<List<CartItemEntity>>) {
  //     _cartItems = result.data;
  //     _errorMessage = null;
  //     isSuccess = true;
  //   } else if (result is ApiFailure<List<CartItemEntity>>) {
  //     _errorMessage = result.failure.message;
  //     isSuccess = false;
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  //   return isSuccess;
  // }

  /// 5. دالة إفراغ السلة بالكامل (Action يرجع bool للـ UI)
  Future<bool> clearCart(int cartId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await cartRepository.clearCart(cartId);

    bool isSuccess = false;

    if (result is Success<List<CartItemEntity>>) {
      _cartItems.clear();
      _errorMessage = null;
      isSuccess = true;
    } else if (result is ApiFailure<List<CartItemEntity>>) {
      _errorMessage = result.failure.message;
      isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  /// دالة تنظيف وتصفير بيانات الشاشة عند الخروج
  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _cartItems = [];
    notifyListeners();
  }
}