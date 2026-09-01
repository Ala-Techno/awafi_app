import 'package:flutter/material.dart';

class CartSummaryBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;

  const CartSummaryBar({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('المجموع الكلي:', style: TextStyle(color: Colors.grey)),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: totalPrice > 0 ? onCheckout : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('متابعة الشراء', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}