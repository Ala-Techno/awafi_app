import '../../../home/domain/entities/product_entity.dart';

// 1. الواجهة المجردة لطبقة البيانات
abstract class SearchLocalDataSource {
  List<ProductEntity> searchProducts(List<ProductEntity> products, String query);
}

// 2. التطبيق الفعلي للبحث المحلي
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  @override
  List<ProductEntity> searchProducts(List<ProductEntity> products, String query) {
    if (query.trim().isEmpty) return [];
    
    final trimmedQuery = query.trim().toLowerCase();
    
    return products.where((product) {
      return product.title.toLowerCase().contains(trimmedQuery);
    }).toList();
  }
}