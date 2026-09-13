import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  const GetCartItemsUseCase(this.repository);

  Future<ApiResult<List<CartItemEntity>>> call(String userId) {
    return repository.getCartItems(userId);
  }
}
