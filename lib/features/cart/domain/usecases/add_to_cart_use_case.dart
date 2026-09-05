import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  const AddToCartUseCase(this.repository);

  Future<ApiResult<List<CartItemEntity>>> call({
    required int userId,
    required int productId,
    required int quantity,
  }) {
    return repository.addToCart(userId, productId, quantity);
  }
}
