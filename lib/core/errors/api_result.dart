import 'failures.dart'; // استدعاء ملف الأخطاء إذا لزم الأمر

abstract class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

// 🟢 قم بتغيير الاسم هنا من Failure إلى ApiFailure أو FailureResult
class ApiFailure<T> extends ApiResult<T> {
  final Failure failure; // يفضل أن يحمل كائن Failure المترجم من الـ Handler
  
  const ApiFailure(this.failure);
}
