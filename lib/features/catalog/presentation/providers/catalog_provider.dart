import 'package:flutter/foundation.dart';
import '../../../../core/errors/api_result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_products_by_category_use_case.dart';

class CatalogProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  CatalogProvider({
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  List<CategoryEntity> _categories = [];
  CategoryEntity? _selectedCategory;
  List<ProductEntity> _categoryProducts = [];

  // كاش ذاكرة للمنتجات حسب القسم لتسريع التنقل الفوري بدون أي تأخير زمني
  final Map<String, List<ProductEntity>> _cachedCategoryProducts = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryEntity> get categories => _categories;
  CategoryEntity? get selectedCategory => _selectedCategory;
  List<ProductEntity> get categoryProducts => _categoryProducts;

  Future<void> fetchCategories({String? preselectedCategoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getCategoriesUseCase();

    if (result is Success<List<CategoryEntity>>) {
      _categories = result.data;
      if (_categories.isNotEmpty && _selectedCategory == null) {
        if (preselectedCategoryId != null) {
          final target = _categories.firstWhere(
            (c) => c.id == preselectedCategoryId,
            orElse: () => _categories.first,
          );
          await selectCategory(target);
        } else {
          await selectCategory(_categories.first);
        }
      }
    } else if (result is ApiFailure<List<CategoryEntity>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCategory(CategoryEntity category, {bool forceReload = false}) async {
    // إذا كان القسم هو نفسه والمنتجات محملة، لا داعي لإعادة الطلب
    if (!forceReload && _selectedCategory?.id == category.id && _categoryProducts.isNotEmpty) {
      return;
    }

    _selectedCategory = category;

    // فحص الكاش الداخلي للتبديل الفوري (0 تأخير)
    if (_cachedCategoryProducts.containsKey(category.id)) {
      _categoryProducts = _cachedCategoryProducts[category.id]!;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    // إذا لم تكن في الكاش، نعرض حالة التحميل ونجلبها
    _isLoading = true;
    _errorMessage = null;
    _categoryProducts = [];
    notifyListeners();

    final result = await getProductsByCategoryUseCase(category.id);

    if (result is Success<List<ProductEntity>>) {
      _categoryProducts = result.data;
      _cachedCategoryProducts[category.id] = result.data;
    } else if (result is ApiFailure<List<ProductEntity>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }
}
