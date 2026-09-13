import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  const ClearCartUseCase(this.repository);

  Future<ApiResult<List<CartItemEntity>>> call(String userId) {
    return repository.clearCart(userId);
  }
}