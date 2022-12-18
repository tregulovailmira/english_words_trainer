import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositiroes/profile_repository.dart';

class CreateProfile extends Usecase<ProfileEntity, CreateProfileParams> {
  CreateProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(
    CreateProfileParams params,
  ) async {
    return await repository.createProfile(params.userId);
  }
}

class CreateProfileParams {
  CreateProfileParams({
    required this.userId,
  });

  final String userId;
}
