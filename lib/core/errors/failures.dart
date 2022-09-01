import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.properties = const []});

  final List<dynamic> properties;

  @override
  List<Object?> get props => [properties];
}

class DataBaseFailure extends Failure {
  DataBaseFailure({required this.message, this.statusCode})
      : super(properties: [message, statusCode]);

  final String message;
  final int? statusCode;
}
