import 'package:awafi_app/app/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأقسام'),
        centerTitle: true,
      ),
      body: Consumer<CatalogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => provider.fetchCategories(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Category chips
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    final isSelected = category == provider.selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            provider.selectCategory(category);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              // Products in selected category
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.categoryProducts.isEmpty
                        ? const Center(child: Text('لا توجد منتجات في هذا القسم'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: provider.categoryProducts.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final product = provider.categoryProducts[index];
                              return ListTile(
                                leading: Image.network(
                                  product.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                ),
                                title: Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.productDetailsScreen,
                                    arguments: product,
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
