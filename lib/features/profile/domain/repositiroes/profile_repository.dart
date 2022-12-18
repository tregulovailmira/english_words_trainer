import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> createProfile(String userId);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileEntity?>> getProfileById(String id);
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    XFile file,
  );
}
