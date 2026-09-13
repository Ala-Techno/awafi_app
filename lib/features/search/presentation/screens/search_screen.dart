import 'package:awafi_app/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

// تأكد من استيراد كارد المنتجات الخاص بك هنا:
// import '../../../home/presentation/widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            return TextField(
              autofocus: true,
              onChanged: provider.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج في عوافي...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              style: const TextStyle(fontSize: 16),
            );
          },
        ),
        actions: [
          Consumer<SearchProvider>(
            builder: (context, provider, child) {
              if (provider.currentQuery.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // مسح حقل البحث وإعادة تعيين النتائج
                    provider.onSearchChanged('');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          // 1. الحالة الأولى: الحقل فارغ (توجيه المستخدم أو عرض رسالة ترحيبية للبحث)
          if (provider.currentQuery.trim().isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'ابدأ الكتابة للبحث عن المنتجات',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // 2. حالة التحميل (Loading)
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. حالة وجود خطأ (Failure)
          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 4. حالة عدم وجود نتائج (Empty Results)
          if (provider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'عذراً، لم نجد نتائج تطابق "${provider.currentQuery}"',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // 5. حالة ظهور النتائج (Success & Data Available)
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عمودين للمنتجات
              childAspectRatio: 0.75, // نسبة الطول للعرض للكارد
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final product = provider.searchResults[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
