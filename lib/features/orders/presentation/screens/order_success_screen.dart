import 'package:awafi_app/app/routing/routes.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderEntity? order;

  const OrderSuccessScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'تم الطلب بنجاح!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              if (order != null) ...[
                Text(
                  'رقم الطلب: #${order!.id}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'المبلغ الإجمالي: \$${order!.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.homeScreen,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.ordersHistoryScreen,
                  );
                },
                child: const Text('عرض سجل الطلبات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
