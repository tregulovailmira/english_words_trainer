import './exceptions.dart';
import './failures.dart';

exceptionHandler(exception) {
  switch (exception.runtimeType) {
    case DataBaseException:
      return DataBaseFailure(
        message: (exception as DataBaseException).message,
        statusCode: exception.statusCode,
      );
    case ApiException:
      return ApiFailure(
        message: (exception as ApiException).message,
        statusCode: exception.statusCode,
      );
    case StorageException:
      return StorageFailure(
        message: (exception as StorageException).message,
        statusCode: exception.statusCode,
      );
    default:
      return UnknownFailure(message: exception.toString());
  }
}
