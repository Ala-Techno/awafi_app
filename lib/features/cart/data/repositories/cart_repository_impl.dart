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
  Future<ApiResult<List<CartItemEntity>>> getCartItems(int userId) async {
    try {
      final cartModels = await remoteDataSource.getCartItems(userId);
      _cachedItems.clear();
      _cachedItems.addAll(cartModels);
      return Success(cartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> addToCart(int userId, int productId, int quantity) async {
    try {
      final updatedCartModels = await remoteDataSource.addToCart(userId, productId, quantity);
      _cachedItems.clear();
      _cachedItems.addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> updateQuantity(int cartId, int productId, int newQuantity) async {
    try {
      final updatedCartModels = await remoteDataSource.updateQuantity(cartId, productId, newQuantity);
      _cachedItems.clear();
      _cachedItems.addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> removeFromCart(int cartId) async {
    try {
      final updatedCartModels = await remoteDataSource.removeFromCart(cartId);
      _cachedItems.clear();
      _cachedItems.addAll(updatedCartModels);
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  Future<ApiResult<List<CartItemEntity>>> clearCart(int userId) async {
    try {
      final updatedCartModels = await remoteDataSource.clearCart(userId);
      _cachedItems.clear();
      return Success(updatedCartModels);
    } catch (error) {
      final Failure failureObj = ApiErrorHandler.handle(error);
      return ApiFailure(failureObj);
    }
  }

  @override
  bool isProductInCart(int productId) {
    return _cachedItems.any((item) => item.product.id == productId);
  }
}