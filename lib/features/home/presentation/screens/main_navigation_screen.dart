import 'package:awafi_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:awafi_app/features/catalog/domain/entities/category_entity.dart';
import 'package:awafi_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:awafi_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:awafi_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/modern_bottom_nav_bar.dart';
import 'home_screen.dart';

/// Scope يتيح لأي عنصر داخل شاشات التطبيق التبديل بين التبويبات بسلاسة
class MainNavigationScope extends InheritedWidget {
  final Function(int tabIndex) switchTab;

  const MainNavigationScope({
    super.key,
    required this.switchTab,
    required super.child,
  });

  static MainNavigationScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainNavigationScope>();
  }

  @override
  bool updateShouldNotify(covariant MainNavigationScope oldWidget) => false;
}

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onCategorySelectedFromHome(CategoryEntity category) {
    // 1. تحديد القسم فوراً وبدون أي تأخير
    context.read<CatalogProvider>().selectCategory(category);
    // 2. التبديل الفوري لتبويب الأقسام في الشريط السفلي
    _switchTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final List<Widget> screens = [
      HomeScreen(
        onSwitchTab: _switchTab,
        onCategoryTap: _onCategorySelectedFromHome,
      ),                                // 0: الصفحة الرئيسية
      const CatalogScreen(),           // 1: شاشة الأقسام
      CartScreen(userId: currentUserId), // 2: شاشة السلة
      const ProfileScreen(),          // 3: شاشة الحساب
    ];

    return MainNavigationScope(
      switchTab: _switchTab,
      child: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentIndex != 0) {
            _switchTab(0);
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: ModernBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _switchTab,
          ),
        ),
      ),
    );
  }
}
