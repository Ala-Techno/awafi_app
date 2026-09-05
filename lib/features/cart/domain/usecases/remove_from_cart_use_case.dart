import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  const RemoveFromCartUseCase(this.repository);

  Future<ApiResult<List<CartItemEntity>>> call(int cartId) {
    return repository.removeFromCart(cartId);
  }
}
