import 'package:awafi_app/app/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

/// [HomeScreen] - شاشة عرض المنتجات (View / UI)
/// 
/// المسؤوليات:
/// 1. استدعاء جلب المنتجات فور فتح الشاشة عبر [initState].
/// 2. الاستماع لتغيرات الكنترولر عبر [Consumer<HomeProvider>].
/// 3. عرض (التحميل - الخطأ - القائمة الفارغة - المنتجات) بناءً على حالة الكنترولر.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // -------------------------------------------------------------
  // 1. Lifecycle Methods (دوال دورة حياة الشاشة)
  // -------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // جلب البيانات فور بناء الإطار الأول للشاشة لتفادي أخطاء الـ Context
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<HomeProvider>().fetchProducts();
    // });
  }

  // -------------------------------------------------------------
  // 2. Widget Tree Build (بناء الواجهة والربط بالـ Provider)
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
  title: const Text('المتجر'),
   actions: [
    //  IconButton(
    //    icon: const Icon(Icons.category_outlined),
    //    onPressed: () {
    //      Navigator.pushNamed(context, Routes.catalogScreen);
    //    },
    //  ),
     IconButton(
       icon: const Icon(Icons.shopping_cart_outlined),
       onPressed: () {
         Navigator.pushNamed(
           context,
           Routes.cartScreen,
           arguments: 1,
         );
       },
     ),
     IconButton(
       icon: const Icon(Icons.person_outline),
       onPressed: () {
         Navigator.pushNamed(context, Routes.profileScreen);
       },
     ),
   ],
),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          // أ) حالة التحميل (Loading State)
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ب) حالة الفشل (Error State)
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // context.read<HomeProvider>().fetchProducts();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          // ج) حالة عدم وجود منتجات (Empty State)
          if (provider.products.isEmpty) {
            return const Center(
              child: Text('لا توجد منتجات حالياً'),
            );
          }

          // د) حالة النجاح وعرض القائمة (Success State)
          return RefreshIndicator(
            onRefresh: () async {
              // await context.read<HomeProvider>().fetchProducts();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return InkWell(
                  onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.productDetailsScreen,
                        arguments: product,
                      );
                  },child: 
                 Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product.price} \$',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                
                );
              },
            ),
          );
        },
        
      ),
      // أضف هذا داخل الـ Scaffold في product_details_screen.dart

    
   );
  }
}