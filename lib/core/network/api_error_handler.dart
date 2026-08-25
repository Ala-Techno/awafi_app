import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "انتهت مهلة الاتصال، يرجى المحاولة لاحقاً";
        case DioExceptionType.badResponse:
          return _handleStatusError(error.response?.statusCode);
        case DioExceptionType.cancel:
          return "تم إلغاء الطلب";
        case DioExceptionType.connectionError:
          return "لا يوجد اتصال بالإنترنت، تحقق من شبكتك";
        default:
          return "حدث خطأ غير متوقع، حاول مجدداً";
      }
    } else {
      return "حدث خطأ في النظام";
    }
  }

  static String _handleStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "طلب غير صالحة";
      case 401:
      case 403:
        return "غير مصرح لك بالوصول، يرجى تسجيل الدخول";
      case 404:
        return "الصفحة أو العنصر غير موجود";
      case 500:
        return "خطأ في السيرفر الداخلي";
      default:
        return "حدث خطأ في الاستجابة من السيرفر";
    }
  }
}