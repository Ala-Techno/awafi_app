import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

/// ─── Abstract Contract ────────────────────────────────────────────────────
abstract class OrdersRemoteDataSource {
  Future<OrderModel> placeOrder(OrderModel order);
  Future<List<OrderModel>> getOrders(String userId);
}

/// ─── Firebase Firestore Implementation ────────────────────────────────────
///
/// هيكل Firestore:
///   orders/{orderId}  →  { userId, date, totalAmount, paymentMethod,
///                          shippingAddress, items[], createdAt }
class OrdersFirebaseDataSourceImpl implements OrdersRemoteDataSource {
  final FirebaseFirestore firestore;

  OrdersFirebaseDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _orders =>
      firestore.collection('orders');

  // ─────────────────────────────────────────────────────────────────────────
  /// حفظ طلب جديد في Firestore مع auto-generated ID
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<OrderModel> placeOrder(OrderModel order) async {
    try {
      final docRef = await _orders.add(order.toFirestore());

      // إعادة OrderModel بمعرّف Firestore الجديد
      return OrderModel(
        id: docRef.id,
        userId: order.userId,
        date: order.date,
        items: order.items,
        totalAmount: order.totalAmount,
        paymentMethod: order.paymentMethod,
        shippingAddress: order.shippingAddress,
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء حفظ الطلب في Firebase',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  /// جلب كل طلبات المستخدم مرتبة من الأحدث للأقدم
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final snapshot = await _orders
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ أثناء جلب سجل الطلبات',
        statusCode: null,
      );
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: $e');
    }
  }
}
