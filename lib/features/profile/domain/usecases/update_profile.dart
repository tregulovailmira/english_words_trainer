import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositiroes/profile_repository.dart';

class UpdateProfile extends Usecase<ProfileEntity, UpdateProfileParams> {
  UpdateProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(
    UpdateProfileParams params,
  ) async {
    return await repository.updateProfile(params.profile);
  }
}

class UpdateProfileParams {
  UpdateProfileParams({
    required this.profile,
  });

  final ProfileEntity profile;
}
