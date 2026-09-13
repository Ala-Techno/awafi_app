import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/data/models/cart_item_model.dart'; // استيراد الـ Model للاستخدام الآمن في الـ State
import 'package:awafi_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:awafi_app/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:awafi_app/features/cart/domain/usecases/get_cart_items_use_case.dart';
import 'package:awafi_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:awafi_app/features/cart/domain/usecases/update_quantity_use_case.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item_entity.dart';

/// [CartController] - مدير حالة السلة
///
/// يتواصل مع Firebase Firestore عبر Use Cases لتخزين السلة السحابي.
/// جميع userId تُستقى من Firebase Auth UID (String).
class CartController extends ChangeNotifier {
  final AddToCartUseCase addToCartUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartController({
    required this.addToCartUseCase,
    required this.getCartItemsUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required this.clearCartUseCase,
  });

  // ── Private State ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;
  List<CartItemEntity> _cartItems = [];

  // ── Public Getters ────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CartItemEntity> get cartItems => _cartItems;

  /// إجمالي المبلغ
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.itemTotalPrice);

  /// إجمالي عدد القطع
  int get totalItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // ── Actions ───────────────────────────────────────────────────────────────

  /// جلب عناصر السلة من Firebase وتحديث الـ state
  Future<void> fetchCartItems(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getCartItemsUseCase.call(userId);

    if (result is Success<List<CartItemEntity>>) {
      _cartItems = result.data;
      _errorMessage = null;
    } else if (result is ApiFailure<List<CartItemEntity>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// إضافة منتج للسلة مع Optimistic Update للـ UI
  Future<bool> addToCart({
    required String userId,
    required ProductEntity product,
    required int quantity,
  }) async {
    _errorMessage = null;

    // Optimistic Update: استخدام CartItemModel لضمان توافق الأنواع تماماً مع الـ List
    final existingIndex =
        _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final existing = _cartItems[existingIndex];
      _cartItems[existingIndex] = CartItemModel(
        id: existing.id,
        product: product,
        quantity: existing.quantity + quantity,
      );
    } else {
      _cartItems.add(CartItemModel(
        id: product.id,           // productId = document ID في Firestore
        product: product,
        quantity: quantity,
      ));
    }
    notifyListeners();

    // إرسال للـ Firebase في الخلفية
    final result = await addToCartUseCase.call(
      userId: userId,
      productId: product.id,
      quantity: quantity,
    );

    if (result is ApiFailure<List<CartItemEntity>>) {
      _errorMessage = result.failure.message;
      // إعادة جلب البيانات الصحيحة عند الفشل
      await fetchCartItems(userId);
      return false;
    } else if (result is Success<List<CartItemEntity>>) {
      _cartItems = result.data;
      notifyListeners();
    }

    return true;
  }

  /// حذف منتج محدد من السلة
  Future<bool> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    // Optimistic Remove
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();

    final result = await removeFromCartUseCase.call(
      userId: userId,
      productId: productId,
    );

    if (result is ApiFailure<List<CartItemEntity>>) {
      _errorMessage = result.failure.message;
      await fetchCartItems(userId);
      return false;
    }

    return true;
  }

  /// تعديل كمية منتج محلياً (للـ UI فوراً)
  void updateQuantityLocal({
    required String productId,
    required int newQuantity,
  }) {
    if (newQuantity <= 0) return;
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      _cartItems[index] = CartItemModel(
        id: _cartItems[index].id,
        product: _cartItems[index].product,
        quantity: newQuantity,
      );
      notifyListeners();
    }
  }

  /// تعديل الكمية محلياً + إرسال للـ Firebase
  Future<void> updateQuantity({
    required String userId,
    required String productId,
    required int newQuantity,
  }) async {
    updateQuantityLocal(productId: productId, newQuantity: newQuantity);

    final result = await updateQuantityUseCase(
      userId: userId,
      productId: productId,
      newQuantity: newQuantity,
    );

    if (result is Success<List<CartItemEntity>>) {
      _cartItems = result.data;
      _errorMessage = null;
      notifyListeners();
    } else if (result is ApiFailure<List<CartItemEntity>>) {
      _errorMessage = result.failure.message;
      notifyListeners();
    }
  }

  /// إفراغ السلة بالكامل
  Future<bool> clearCart(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await clearCartUseCase(userId);

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

  /// تنظيف الحالة عند الخروج
  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _cartItems = [];
    notifyListeners();
  }
}