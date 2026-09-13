import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems(String userId);
  Future<List<CartItemModel>> addToCart(String userId, String productId, int quantity);
  Future<List<CartItemModel>> updateQuantity(String userId, String productId, int newQuantity);
  Future<List<CartItemModel>> removeFromCart(String userId, String productId);
  Future<List<CartItemModel>> clearCart(String userId);
}

class CartFirebaseDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartFirebaseDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _cartItems(String userId) =>
      firestore.collection('carts').doc(userId).collection('items');

  DocumentReference<Map<String, dynamic>> _productDoc(String productId) =>
      firestore.collection('products').doc(productId);

  @override
  Future<List<CartItemModel>> getCartItems(String userId) async {
    try {
      final snapshot = await _cartItems(userId).get();
      if (snapshot.docs.isEmpty) return [];

      final futures = snapshot.docs.map((doc) async {
        final data = doc.data();
        final productId = data['productId'] ?? doc.id;
        final productSnap = await _productDoc(productId).get();

        if (!productSnap.exists) return null;

        final product = ProductModel.fromJson({
          'id': productSnap.id,
          ...productSnap.data()!,
        });

        return CartItemModel.fromFirestore(doc: doc, product: product);
      });

      final results = await Future.wait(futures);
      return results.whereType<CartItemModel>().toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ في الاتصال بـ Firestore',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> addToCart(
      String userId, String productId, int quantity) async {
    try {
      final docRef = _cartItems(userId).doc(productId);
      final existing = await docRef.get();

      if (existing.exists) {
        final currentQty = existing.data()?['quantity'] as int? ?? 0;
        await docRef.update({'quantity': currentQty + quantity});
      } else {
        await docRef.set({
          'productId': productId,
          'quantity': quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      return getCartItems(userId);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء الإضافة للسلة',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> updateQuantity(
      String userId, String productId, int newQuantity) async {
    try {
      await _cartItems(userId).doc(productId).update({'quantity': newQuantity});
      return getCartItems(userId);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء تعديل الكمية',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> removeFromCart(
      String userId, String productId) async {
    try {
      await _cartItems(userId).doc(productId).delete();
      return getCartItems(userId);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء حذف المنتج من السلة',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  @override
  Future<List<CartItemModel>> clearCart(String userId) async {
    try {
      final snapshot = await _cartItems(userId).get();
      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return [];
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء إفراغ السلة',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }
}