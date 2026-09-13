import '../../../../core/errors/api_error_handler.dart';
import '../../../../core/errors/api_result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final List<CartItemEntity> _cachedItems = [];

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<CartItemEntity>>> getCartItems(String userId) async {
    try {
      final cartModels = await remoteDataSource.getCartItems(userId);
      _cachedItems
        ..clear()
        ..addAll(cartModels);
      return Success(cartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> addToCart(
      String userId, String productId, int quantity) async {
    try {
      final updatedCartModels =
          await remoteDataSource.addToCart(userId, productId, quantity);
      _cachedItems
        ..clear()
        ..addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> updateQuantity(
      String userId, String productId, int newQuantity) async {
    try {
      final updatedCartModels =
          await remoteDataSource.updateQuantity(userId, productId, newQuantity);
      _cachedItems
        ..clear()
        ..addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> removeFromCart(
      String userId, String productId) async {
    try {
      final updatedCartModels =
          await remoteDataSource.removeFromCart(userId, productId);
      _cachedItems
        ..clear()
        ..addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> clearCart(String userId) async {
    try {
      await remoteDataSource.clearCart(userId);
      _cachedItems.clear();
      return Success([]);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  bool isProductInCart(String productId) {
    return _cachedItems.any((item) => item.product.id == productId);
  }
}