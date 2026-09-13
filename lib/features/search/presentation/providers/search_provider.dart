import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awafi_app/core/errors/api_result.dart'; // تأكد من مسار الـ ApiResult لديك
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/usecases/search_products_usecase.dart';

class SearchProvider extends ChangeNotifier {
  final SearchProductsUseCase searchProductsUseCase;
  

  SearchProvider(this.searchProductsUseCase);

  List<ProductEntity> _searchResults = [];
  List<ProductEntity> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Timer? _debounceTimer;

  // دالة البحث مع تطبيق الـ Debounce لمنع الضغط والطلبات المتكررة مع كل حرف
 void onSearchChanged(String query) {
    _currentQuery = query;

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    // تم إزالة _isLoading = true لتجنب وميض شاشة التحميل في البحث المحلي الفوري
    _errorMessage = null; 
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      final result = await searchProductsUseCase(query);

      _isLoading = false;

      result.when(
        success: (data) {
          _searchResults = data;
          _errorMessage = null;
        },
        failure: (error) {
          _searchResults = [];
          _errorMessage = error.toString();
        },
      );

      notifyListeners();
    });
  }
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}