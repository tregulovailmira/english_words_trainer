import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

abstract class UsecaseSync<Type, Params> {
  Either<Failure, Type?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
