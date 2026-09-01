import 'package:awafi_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:awafi_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:awafi_app/features/cart/presentation/widgets/cart_summary_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatefulWidget {
  final int userId;
  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // 1. Initializ (جلب البيانات أول ما تفتح الشاشة)
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<CartController>().fetchCartItems(widget.userId);
    // });
  }

  // 2. الشاشة نفسها (Build Method)
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    // final cartController = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        centerTitle: true,
      ),
      body: cartController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartController.cartItems.isEmpty
              ? const Center(child: Text('السلة فارغة حالياً'))
              : ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return CartItemTile(
                      item: item,
                      onIncrement: () {
                       cartController.updateQuantityLocal(
  cartItemId: item.id,
  newQuantity: item.quantity + 1,
);
                      },
                      onDecrement: () {
                       if (item.quantity > 1) {
  cartController.updateQuantityLocal(
    cartItemId: item.id,
    newQuantity: item.quantity - 1,
  );
                        }
                      },
                      onRemove: () {
                        cartController.removeFromCart(item.id);
                      },
                    );
                  },
                ),
      bottomNavigationBar: cartController.cartItems.isEmpty
          ? null
          : CartSummaryBar(
              totalPrice: cartController.totalPrice,
              onCheckout: () {
                // الانتقال لشاشة اتمام الشراء
              },
            ),
    );
  }
}