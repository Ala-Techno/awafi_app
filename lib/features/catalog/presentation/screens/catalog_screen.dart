import 'package:awafi_app/core/theme/app_colors.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import 'package:awafi_app/features/catalog/presentation/widgets/category_list_widget.dart';
import 'package:awafi_app/features/catalog/presentation/widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/catalog_provider.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategoryId;

  const CatalogScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeCategorySelection();
    });
  }

  @override
  void didUpdateWidget(covariant CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != oldWidget.initialCategoryId &&
        widget.initialCategoryId != null) {
      final provider = context.read<CatalogProvider>();
      _applyTargetSelection(provider);
    }
  }

  Future<void> _initializeCategorySelection() async {
    final provider = context.read<CatalogProvider>();
    
    // إذا القائمة فارغة، نقوم بجلبها أولاً
    if (provider.categories.isEmpty) {
      await provider.fetchCategories();
      if (!mounted) return;
    }

    _applyTargetSelection(provider);
  }

  // الدالة المسؤولة عن مطابقة الـ ID واختياره بشكل آمن ونظيف
  void _applyTargetSelection(CatalogProvider provider) {
    if (provider.categories.isEmpty) return;

    final targetId = widget.initialCategoryId;
    CategoryEntity? matchedCategory;

    if (targetId != null && targetId.isNotEmpty && targetId != 'null') {
      for (final category in provider.categories) {
        if (category.id.toString().trim() == targetId.trim()) {
          matchedCategory = category;
          break;
        }
      }
    }

    if (matchedCategory != null) {
      if (provider.selectedCategory?.id != matchedCategory.id) {
        provider.selectCategory(matchedCategory);
      }
      return;
    }

    // إذا كان هناك قسم محدد بالفعل، نحافظ عليه ولا نعيد تغييره للقسم الأول
    if (provider.selectedCategory != null) {
      return;
    }

    provider.selectCategory(provider.categories.first);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
               'قائمة المنتجات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(CatalogProvider provider) {
    // حالة التحميل الأولية للأقسام
    if (provider.isLoading && provider.categories.isEmpty) {
      return _buildCategoriesShimmer();
    }

    // حالة الخطأ
    if (provider.errorMessage != null && provider.categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _initializeCategorySelection(),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // شريط الأقسام الأفقي مع إبراز القسم النشط
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child:  const Text(
                'الأقسام',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
        ),
        CategoryListWidget(
          categories: provider.categories,
          selectedCategory: provider.selectedCategory,
          onCategorySelected: (category) {
            provider.selectCategory(category);
          },
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),

        // شبكة المنتجات
        Expanded(
          child: provider.isLoading
              ? _buildProductsShimmer()
              : provider.categoryProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد منتجات في هذا القسم',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ProductGridWidget(products: provider.categoryProducts),
        ),
      ],
    );
  }

  // تأثير التحميل للشاشات (Shimmer Effect للأقسام)
  Widget _buildCategoriesShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, height: 20, color: Colors.white),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (_, __) => Container(
                  width: 90,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 4,
                itemBuilder: (_, __) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تأثير التحميل للمنتجات
  Widget _buildProductsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}