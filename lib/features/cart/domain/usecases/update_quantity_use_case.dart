import '../../../../core/errors/api_result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository repository;

  const UpdateQuantityUseCase(this.repository);

  Future<ApiResult<List<CartItemEntity>>> call({
    required String userId,
    required String productId,
    required int newQuantity,
  }) {
    return repository.updateQuantity(userId, productId, newQuantity);
  }
}