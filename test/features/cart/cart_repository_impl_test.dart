import 'package:awafi_app/core/errors/api_result.dart';
import 'package:awafi_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:awafi_app/features/cart/data/models/cart_item_model.dart';
import 'package:awafi_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:awafi_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:awafi_app/features/home/data/models/product_model.dart';
import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCartRemoteDataSource implements CartRemoteDataSource {
  final List<CartItemModel> items = [];

  @override
  Future<List<CartItemModel>> getCartItems(int userId) async {
    return List.from(items);
  }

  @override
  Future<List<CartItemModel>> addToCart(int userId, int productId, int quantity) async {
    final newItem = CartItemModel(
      id: productId,
      product: ProductModel(
        id: productId,
        title: 'Product $productId',
        price: 10.0,
        image: '',
        description: '',
        category: 'general',
        rating: const ProductRating(rate: 4.0, count: 5),
      ),
      quantity: quantity,
    );
    items.add(newItem);
    return List.from(items);
  }

  @override
  Future<List<CartItemModel>> updateQuantity(int cartId, int productId, int newQuantity) async {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      items[index] = CartItemModel(
        id: items[index].id,
        product: items[index].product,
        quantity: newQuantity,
      );
    }
    return List.from(items);
  }

  @override
  Future<List<CartItemModel>> removeFromCart(int cartId) async {
    items.removeWhere((item) => item.id == cartId);
    return List.from(items);
  }

  @override
  Future<List<CartItemModel>> clearCart(int cartId) async {
    items.clear();
    return [];
  }
}

void main() {
  late FakeCartRemoteDataSource fakeRemoteDataSource;
  late CartRepositoryImpl cartRepository;

  setUp(() {
    fakeRemoteDataSource = FakeCartRemoteDataSource();
    cartRepository = CartRepositoryImpl(remoteDataSource: fakeRemoteDataSource);
  });

  group('CartRepositoryImpl', () {
    test('addToCart adds item and isProductInCart returns true', () async {
      final result = await cartRepository.addToCart(1, 101, 2);

      expect(result, isA<Success<List<CartItemEntity>>>());
      expect(cartRepository.isProductInCart(101), isTrue);
      expect(cartRepository.isProductInCart(999), isFalse);
    });

    test('removeFromCart removes item from cart', () async {
      await cartRepository.addToCart(1, 101, 2);
      expect(cartRepository.isProductInCart(101), isTrue);

      final result = await cartRepository.removeFromCart(101);

      expect(result, isA<Success<List<CartItemEntity>>>());
      expect(cartRepository.isProductInCart(101), isFalse);
    });

    test('clearCart empties cart and isProductInCart returns false', () async {
      await cartRepository.addToCart(1, 101, 1);
      await cartRepository.addToCart(1, 102, 1);

      final result = await cartRepository.clearCart(1);

      expect(result, isA<Success<List<CartItemEntity>>>());
      final success = result as Success<List<CartItemEntity>>;
      expect(success.data, isEmpty);
      expect(cartRepository.isProductInCart(101), isFalse);
    });
  });
}
