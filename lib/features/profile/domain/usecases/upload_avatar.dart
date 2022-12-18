import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositiroes/profile_repository.dart';

class UploadAvatar extends Usecase<String, UploadAvatarParams> {
  UploadAvatar(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, String>> call(
    UploadAvatarParams params,
  ) async {
    return await repository.uploadAvatar(params.userId, params.file);
  }
}

class UploadAvatarParams {
  UploadAvatarParams({
    required this.userId,
    required this.file,
  });

  final String userId;
  final XFile file;
}
