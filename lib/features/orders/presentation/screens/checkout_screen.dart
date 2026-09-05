import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final int userId;

  const CheckoutScreen({super.key, this.userId = 1});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController(text: 'الرياض، المملكة العربية السعودية');
  String _selectedPaymentMethod = 'بطاقة ائتمان / مدى';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _processCheckout(CartController cartController) async {
    final ordersProvider = context.read<OrdersProvider>();
    final items = cartController.cartItems;
    final total = cartController.totalPrice;

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السلة فارغة')),
      );
      return;
    }

    final success = await ordersProvider.placeOrder(
      userId: widget.userId,
      items: List.from(items),
      totalAmount: total,
      paymentMethod: _selectedPaymentMethod,
      shippingAddress: _addressController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      await cartController.clearCart(widget.userId);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        Routes.orderSuccessScreen,
        arguments: ordersProvider.lastPlacedOrder,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ordersProvider.errorMessage ?? 'فشلت عملية الدفع'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final ordersProvider = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ملخص الطلب
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملخص الطلب',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('عدد المنتجات: ${cartController.cartItems.length}'),
                        Text(
                          '\$${cartController.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // عنوان الشحن
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عنوان الشحن',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'عنوان التوصيل',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // طريقة الدفع
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طريقة الدفع',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<String>(
                      title: const Text('بطاقة ائتمان / مدى'),
                      value: 'بطاقة ائتمان / مدى',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPaymentMethod = val);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('الدفع عند الاستلام'),
                      value: 'الدفع عند الاستلام',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPaymentMethod = val);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Apple Pay / Google Pay'),
                      value: 'Apple Pay / Google Pay',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPaymentMethod = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // زر تأكيد الطلب
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: ordersProvider.isLoading
                    ? null
                    : () => _processCheckout(cartController),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: ordersProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'تأكيد الطلب والدفع',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
