import 'package:dio/dio.dart';
import 'package:awafi_app/core/errors/failures.dart';
import 'exceptions.dart';

class ApiErrorHandler {
  static Failure handle(dynamic error) {

 // ==========================================
    // 0. الاستثناءات الخاصة (Custom Exceptions) المرمية يدوياً من الـ DataSource
    // ==========================================
    if (error is ServerException) {
      // استخدام ?? لإعطاء نص احتياطي في حال كانت message فارغة أو null
      return ServerFailure(error.message ?? "حدث خطأ في السيرفر");
    } 
    else if (error is CacheException) {
      return CacheFailure(error.message ?? "حدث خطأ في الذاكرة المؤقتة");
    }

    // ==========================================
    // 1. النوع الأول: أخطاء من عند المستخدم (الشبكة والتغطية والجهاز)
    // ==========================================
    else if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ServerFailure("انتهت مهلة الاتصال، يرجى المحاولة لاحقاً");

        case DioExceptionType.connectionError:
          return const NetworkFailure("لا يوجد اتصال بالإنترنت، تحقق من شبكتك");

        case DioExceptionType.cancel:
          return const ServerFailure("تم إلغاء الطلب");

    

        // ==========================================
        // 2. النوع الثاني: أخطاء راجعة من السيرفر
        // ==========================================
        case DioExceptionType.badResponse:
          return ServerFailure(
            _parseServerError(error.response),
            statusCode: error.response?.statusCode,
          );

        default:
          return const ServerFailure("حدث خطأ في الشبكة، حاول مجدداً");
      }
    } 
    // ==========================================
    // 3. النوع الثالث: أخطاء من داخل كود التطبيق نفسه
    // ==========================================
    else if (error is FormatException) {
      return const ServerFailure("خطأ في معالجة وتحويل البيانات القادمة من السيرفر");
    } else if (error is TypeError) {
      return const ServerFailure("حدث خطأ في عدم تطابق أنواع البيانات الداخلية");
    } else {
      return ServerFailure("حدث خطأ غير متوقع في النظام: ${error.toString()}");
    }
  }

  /// دالة قراءة رسالة السيرفر الديناميكية أو الاستعانة بالأرقام الاحتياطية
  static String _parseServerError(Response? response) {
    if (response?.data != null && response?.data is Map) {
      final serverMessage = response?.data['message'] ?? response?.data['error'];
      if (serverMessage != null && serverMessage.toString().isNotEmpty) {
        return serverMessage.toString();
      }
    }
    return _handleStatusError(response?.statusCode);
  }

  /// الأرقام الاحتياطية لأخطاء السيرفر
  static String _handleStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "بيانات الطلب غير صالحة";
      case 401:
      case 403:
        return "غير مصرح لك بالوصول، يرجى تسجيل الدخول";
      case 404:
        return "الصفحة أو العنصر غير موجود";
      case 500:
        return "خطأ في السيرفر الداخلي، يرجى المحاولة لاحقاً";
      default:
        return "حدث خطأ غير متوقع في الاستجابة من السيرفر";
    }
  }
}



//     حل مختلف عشان مشكلة SocketException
// ____________________________________________
// __________________________________


// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:awafi_app/core/errors/failures.dart';
// import 'exceptions.dart';

// class ApiErrorHandler {
//   static Failure handle(dynamic error) {

//     // 0. الاستثناءات الخاصة المرمية يدوياً
//     if (error is ServerException) {
//       return ServerFailure(error.message ?? "حدث خطأ في السيرفر");
//     } 
//     else if (error is CacheException) {
//       return CacheFailure(error.message ?? "حدث خطأ في الذاكرة المؤقتة");
//     }

//     // 1. أخطاء Dio والشبكة
//     else if (error is DioException) {
//       switch (error.type) {
//         case DioExceptionType.connectionTimeout:
//         case DioExceptionType.sendTimeout:
//         case DioExceptionType.receiveTimeout:
//           return const ServerFailure("انتهت مهلة الاتصال، يرجى المحاولة لاحقاً");

//         case DioExceptionType.connectionError:
//           return const NetworkFailure("لا يوجد اتصال بالإنترنت، تحقق من شبكتك");

//         case DioExceptionType.cancel:
//           return const ServerFailure("تم إلغاء الطلب");

//         case DioExceptionType.badResponse:
//           return ServerFailure(
//             _parseServerError(error.response),
//             statusCode: error.response?.statusCode,
//           );

//         // 🟢 حل المشكلة الأساسية: إذا كان الخطأ unknown بسبب SocketException أو عدم وجود إنترنت
//         case DioExceptionType.unknown:
//         default:
//           if (error.error is SocketException) {
//             return const NetworkFailure("لا يوجد اتصال بالإنترنت أو تعذر الوصول للسيرفر");
//           }
//           return const ServerFailure("حدث خطأ غير متوقع في الاتصال بالسيرفر");
//       }
//     } 

//     // 2. فحص SocketException بشكل مباشر لو جاء الخطأ من خارج Dio
//     else if (error is SocketException) {
//       return const NetworkFailure("لا يوجد اتصال بالإنترنت، تحقق من شبكتك");
//     }

//     // 3. أخطاء تحويل البيانات داخل التطبيق
//     else if (error is FormatException) {
//       return const ServerFailure("خطأ في معالجة وتحويل البيانات القادمة من السيرفر");
//     } else if (error is TypeError) {
//       return const ServerFailure("حدث خطأ في عدم تطابق أنواع البيانات الداخلية");
//     } else {
//       return ServerFailure("حدث خطأ غير متوقع في النظام: ${error.toString()}");
//     }
//   }

//   /// دالة قراءة رسالة السيرفر الديناميكية
//   static String _parseServerError(Response? response) {
//     if (response?.data != null && response?.data is Map) {
//       final serverMessage = response?.data['message'] ?? response?.data['error'];
//       if (serverMessage != null && serverMessage.toString().isNotEmpty) {
//         return serverMessage.toString();
//       }
//     }
//     return _handleStatusError(response?.statusCode);
//   }

//   /// الأرقام الاحتياطية لأخطاء السيرفر
//   static String _handleStatusError(int? statusCode) {
//     switch (statusCode) {
//       case 400:
//         return "بيانات الطلب غير صالحة";
//       case 401:
//       case 403:
//         return "غير مصرح لك بالوصول، يرجى تسجيل الدخول";
//       case 404:
//         return "الصفحة أو العنصر غير موجود";
//       case 500:
//         return "خطأ في السيرفر الداخلي، يرجى المحاولة لاحقاً";
//       default:
//         return "حدث خطأ غير متوقع في الاستجابة من السيرفر";
//     }
//   }
// }