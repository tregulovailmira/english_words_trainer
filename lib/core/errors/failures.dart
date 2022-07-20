import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  const Failure({this.properties = const []});
  // Failure([List properties = const []])
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
