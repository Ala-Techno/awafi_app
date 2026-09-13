import 'package:awafi_app/core/errors/failures.dart';

abstract class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is ApiFailure<T>) {
      return failure((this as ApiFailure<T>).failure);
    }
    throw Exception('Invalid ApiResult state');
  }
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}