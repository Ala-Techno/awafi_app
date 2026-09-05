import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:awafi_app/features/orders/domain/entities/order_entity.dart';
import 'package:awafi_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:awafi_app/features/orders/domain/usecases/place_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeOrdersRepository implements OrdersRepository {
  @override
  Future<ApiResult<OrderEntity>> placeOrder({
    required int userId,
    required List<CartItemEntity> items,
    required double totalAmount,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    final order = OrderEntity(
      id: 12345,
      userId: userId,
      date: '2026-09-05',
      products: items,
      totalAmount: totalAmount,
    );
    return Success(order);
  }

  @override
  Future<ApiResult<List<OrderEntity>>> getOrderHistory(int userId) async {
    return const Success([]);
  }
}

void main() {
  late FakeOrdersRepository fakeOrdersRepository;
  late PlaceOrderUseCase placeOrderUseCase;

  setUp(() {
    fakeOrdersRepository = FakeOrdersRepository();
    placeOrderUseCase = PlaceOrderUseCase(fakeOrdersRepository);
  });

  group('PlaceOrderUseCase', () {
    test('successfully places order with given items and total', () async {
      final items = [
        const CartItemEntity(
          id: 1,
          product: ProductEntity(
            id: 1,
            title: 'Sample Product',
            price: 50.0,
            image: '',
            description: '',
            category: 'test',
            rating: ProductRating(rate: 4.5, count: 2),
          ),
          quantity: 2,
        ),
      ];

      final result = await placeOrderUseCase(
        userId: 1,
        items: items,
        totalAmount: 100.0,
        paymentMethod: 'بطاقة ائتمان',
        shippingAddress: 'الرياض',
      );

      expect(result, isA<Success<OrderEntity>>());
      final success = result as Success<OrderEntity>;
      expect(success.data.id, 12345);
      expect(success.data.totalAmount, 100.0);
      expect(success.data.products.length, 1);
    });
  });
}
