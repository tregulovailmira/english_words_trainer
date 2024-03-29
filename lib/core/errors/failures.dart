import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.properties = const []});

  final List<dynamic> properties;

  @override
  List<Object?> get props => properties;
}

class DataBaseFailure extends Failure {
  DataBaseFailure({required this.message, this.statusCode})
      : super(properties: [message, statusCode]);

  final String message;
  final int? statusCode;
}

class ApiFailure extends Failure {
  ApiFailure({required this.message, this.statusCode})
      : super(properties: [message, statusCode]);

  final String message;
  final int? statusCode;
}

class StorageFailure extends Failure {
  StorageFailure({required this.message, this.statusCode})
      : super(properties: [message, statusCode]);

  final String message;
  final String? statusCode;
}

class UnknownFailure extends Failure {
  UnknownFailure({required this.message}) : super(properties: [message]);

  final String message;
}
