class DataBaseException implements Exception {
  DataBaseException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;
}

class ApiException implements Exception {
  ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;
}

class StorageException implements Exception {
  StorageException(this.message, [this.statusCode]);

  final String message;
  final String? statusCode;
}
