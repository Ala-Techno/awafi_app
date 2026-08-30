import 'package:awafi_app/app/routing/routes.dart';
import 'package:awafi_app/core/localization/l10n/app_strings.dart';
import 'package:awafi_app/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// [LoginPage] - شاشة تسجيل الدخول (View / UI)
/// 
/// المسؤوليات:
/// 1. رسم عناصر الواجهة (حقول البريد، كلمة المرور، زر الدخول).
/// 2. إدارة دورة حياة متحكمات حقول النصوص (TextEditingController) وتنظيف الذاكرة.
/// 3. استقبال كبسات الأزرار واستدعاء الكنترولر (AuthProvider).
/// 4. التفاعل مع ردود أفعال الكنترولر (عرض دائرة التحميل، الانتقال، إظهار رسالة الخطأ).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // -------------------------------------------------------------
  // 1. UI Local State & Controllers (متحكمات ذاكرة الواجهة فقط)
  // -------------------------------------------------------------
  /// مفتاح الـ Form للتأكد من صحة البيانات المدخلة قبل الإرسال
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// متحكمات حقول النصوص لقراءة المدخلات
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // -------------------------------------------------------------
  // 2. Lifecycle Methods (دوال إدارة ذاكرة RAM)
  // -------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // حجز مساحة في الذاكرة لمتحكمات النصوص فور فتح الشاشة
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // تدمير وتفريغ متحكمات النصوص من الذاكرة فور إغلاق الشاشة لمنع Memory Leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------
  // 3. User Action Handler (دالة معالجة ضغط زر الدخول)
  // -------------------------------------------------------------
  Future<void> _handleLogin( ) async {
    // أ) التأكد من صحة كتابة الإيميل والباسورد في الحقول
    if (!_formKey.currentState!.validate()) return;

    // ب) استدعاء دالة الكنترولر وتمرير البيانات الصافية وانتظار نتيجة الـ bool
    final bool isSuccess = await context.read<AuthProvider>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // ج) الحماية: التأكد من أن الشاشة ما زالت مفتوحة وموجودة في الشجرة قبل استخدام context
    if (!mounted) return;

    // د) اتخاذ قرار الشاشة بناءً على النتيجة الراجعة من الكنترولر
    if (isSuccess) {
      // حالة النجاح: الانتقال للشاشة الرئيسية وتدمير شاشة الدخول من مكدس الشاشات
Navigator.pushReplacementNamed(context, Routes.homeScreen);    } else {
      // حالة الفشل: عرض شريط تنبيه بصري (SnackBar) يحوي نص الخطأ القادم من الكنترولر
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<AuthProvider>().errorMessage ?? 'حدث خطأ في تسجيل الدخول'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // -------------------------------------------------------------
  // 4. Widget Tree Build (رسم مكونات الواجهة والربط بالـ Provider)
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
  //   // نأخذ نسخة من الكنترولر بدون استماع (listen: false) 
  // // لأننا نقتصر على استدعاء دالة _handleLogin فقط
  // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(AppStrings.login),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- حقل البريد الإلكتروني ---
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- حقل كلمة المرور ---
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- الزر الديناميكي (يتغير مع حالة الكنترولر) ---
                Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return ElevatedButton(

               onPressed: provider.isLoading ? null : _handleLogin,
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('تسجيل الدخول'),
              );
            },
          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}