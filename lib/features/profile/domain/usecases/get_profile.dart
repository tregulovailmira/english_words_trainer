import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositiroes/profile_repository.dart';

class GetProfile extends Usecase<ProfileEntity, GetProfileParams> {
  GetProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, ProfileEntity?>> call(GetProfileParams params) async {
    return await repository.getProfileById(params.id);
  }
}

class GetProfileParams {
  GetProfileParams({
    required this.id,
  });

  final String id;
}
