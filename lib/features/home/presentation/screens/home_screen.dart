import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/constants/app_assets.dart';
import 'package:awafi_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:awafi_app/features/home/presentation/widgets/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import '../providers/home_provider.dart';
import 'main_navigation_screen.dart';

/// [HomeScreen] - الشاشة الرئيسية للمتجر (View / UI)
class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex)? onSwitchTab;
  final void Function(CategoryEntity category)? onCategoryTap;

  const HomeScreen({
    super.key,
    this.onSwitchTab,
    this.onCategoryTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات فور بناء الإطار الأول لتفادي أخطاء الـ Context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchBanners();
      context.read<HomeProvider>().fetchProducts();
      context.read<CatalogProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('متجر عوافي'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'التصنيفات',
            icon: const Icon(Icons.category_outlined),
            onPressed: () {
              if (widget.onSwitchTab != null) {
                widget.onSwitchTab!(1);
              } else if (MainNavigationScope.of(context) != null) {
                MainNavigationScope.of(context)!.switchTab(1);
              } else {
                Navigator.pushNamed(context, Routes.catalogScreen);
              }
            },
          ),
          IconButton(
            tooltip: 'سلة المشتريات',
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              if (widget.onSwitchTab != null) {
                widget.onSwitchTab!(2);
              } else if (MainNavigationScope.of(context) != null) {
                MainNavigationScope.of(context)!.switchTab(2);
              } else {
                Navigator.pushNamed(context, Routes.cartScreen, arguments: 1);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // القسم الأول: شريط البحث العلوي (Top Search Bar)
              // -------------------------------------------------------------
              _buildTopSearchBar(context),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // القسم الثاني: البانرات الإعلانية المتحركة (Banner Slider)
              // -------------------------------------------------------------
              _buildBannerSliderSection(context),
              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // القسم الثالث: التصنيفات الأفقية (Categories List)
              // -------------------------------------------------------------
              _buildCategoriesSection(context),
              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // القسم الرابع: شبكة المنتجات (Featured Products Grid)
              // -------------------------------------------------------------
              _buildProductsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. شريط البحث والتصفح السريع
  Widget _buildTopSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.searchScreen);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'ابحث عن منتجات عوافي...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 2. قسم البانرات الإعلانية
  Widget _buildBannerSliderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'عروض عوافي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? SizedBox(
                    height: 160.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                : provider.errorMessage != null
                    ? SizedBox(
                        height: 160,
                        child: Center(
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : provider.banners.isEmpty
                        ? const SizedBox(
                            height: 160,
                            child: Center(child: Text('لا توجد عروض متاحة حالياً')),
                          )
                        : CarouselSlider.builder(
                            itemCount: provider.banners.length,
                            itemBuilder: (context, index, realIndex) {
                              final banner = provider.banners[index];
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: banner.imageUrl.isEmpty
                                      ? Image.asset(
                                          index == 0
                                              ? AppAssets.banner
                                              : AppAssets.banner2,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: banner.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            AppAssets.banner,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 160.0,
                              autoPlay: provider.banners.length > 1,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              autoPlayInterval: const Duration(seconds: 4),
                              viewportFraction: 0.88,
                            ),
                          );
          },
        ),
      ],
    );
  }

  /// 3. قسم التصنيفات الدائرية الأفقية
  Widget _buildCategoriesSection(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalogProvider, child) {
        if (catalogProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'الأقسام',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: catalogProvider.categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = catalogProvider.categories[index];
                  return GestureDetector(
                    onTap: () {
                      // 1. تحديد القسم فوراً في البروفايدر بدون أي تأخير
                      context.read<CatalogProvider>().selectCategory(category);

                      // 2. التبديل الفوري لتبويب الأقسام في الشريط السفلي
                      if (widget.onCategoryTap != null) {
                        widget.onCategoryTap!(category);
                      } else if (widget.onSwitchTab != null) {
                        widget.onSwitchTab!(1);
                      } else if (MainNavigationScope.of(context) != null) {
                        MainNavigationScope.of(context)!.switchTab(1);
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.catalogScreen,
                          arguments: category.id,
                        );
                      }
                    },
                    child: SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.category_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// 4. شبكة المنتجات
  Widget _buildProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المنتجات المتاحة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              // أ) حالة التحميل
              if (provider.isLoading) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // ب) حالة الخطأ
              if (provider.errorMessage != null) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => provider.fetchProducts(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // ج) حالة القائمة الفارغة
              if (provider.products.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: Text('لا توجد منتجات عوافي حالياً')),
                );
              }

              // د) حالة النجاح وعرض الشبكة
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return ProductCard(product: product);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
