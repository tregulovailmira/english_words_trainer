import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/errors_handlers.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositiroes/profile_repository.dart';
import '../datasources/profile_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);
  @override
  Future<Either<Failure, ProfileEntity>> createProfile(String userId) async {
    try {
      final result = await dataSource.createProfile(userId);

      return Right(result.toDomain());
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getProfileById(String id) async {
    try {
      final result = await dataSource.getProfile(id);
      return Right(result?.toDomain());
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      final result =
          await dataSource.updateProfile(ProfileModel.fromDomain(profile));

      return Right(result.toDomain());
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    XFile file,
  ) async {
    try {
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${clock.now().toIso8601String()}.$fileExt';
      await dataSource.removeOldAvatarFromStorage(userId);
      final avatarUrl = await dataSource.uploadAvatarToStrorage(
        userId: userId,
        fileName: fileName,
        bytes: bytes,
      );

      await dataSource.updateAvatarUrlAtProfile(userId, avatarUrl);

      return Right(avatarUrl);
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }
}
