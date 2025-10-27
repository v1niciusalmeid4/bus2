sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T) success,
    required R Function(String) error,
  }) {
    final self = this;

    if (self is Success<T>) {
      return success(self.data);
    } else {
      final failure = self as Failure<T>;

      return error(failure.message);
    }
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
