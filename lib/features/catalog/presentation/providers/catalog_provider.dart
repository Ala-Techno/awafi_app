import 'package:awafi_app/core/errors/api_result.dart';
import 'package:flutter/foundation.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';

class CatalogProvider extends ChangeNotifier {
  final CatalogRepository catalogRepository;

  CatalogProvider({required this.catalogRepository});

  bool _isLoading = false;
  String? _errorMessage;
  List<String> _categories = [];
  String? _selectedCategory;
  List<ProductEntity> _categoryProducts = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  List<ProductEntity> get categoryProducts => _categoryProducts;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await catalogRepository.getCategories();

    if (result is Success<List<String>>) {
      _categories = result.data;
      if (_categories.isNotEmpty && _selectedCategory == null) {
        await selectCategory(_categories.first);
      }
    } else if (result is ApiFailure<List<String>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await catalogRepository.getProductsByCategory(category);

    if (result is Success<List<ProductEntity>>) {
      _categoryProducts = result.data;
    } else if (result is ApiFailure<List<ProductEntity>>) {
      _errorMessage = result.failure.message;
    }

    _isLoading = false;
    notifyListeners();
  }
}
