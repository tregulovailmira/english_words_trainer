import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/profile/domain/repositiroes/profile_repository.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/upload_avatar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/upload_avatar_test.mocks.dart';


@GenerateMocks([XFile, ProfileRepository])
void main() {
  late final UploadAvatar usecase;
  late final MockProfileRepository mockRepository;
  late final MockXFile mockXFile;
  const tUserId = '123';

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UploadAvatar(mockRepository);
    mockXFile = MockXFile();
  });

  test('should return uploaded avatar url via repository', () async {
    // arrange
    const tExpectedUrl = 'https://testavatar.com';
    when(mockRepository.uploadAvatar(tUserId, mockXFile))
        .thenAnswer((_) async => const Right(tExpectedUrl));

    // act
    final result = await usecase(
      UploadAvatarParams(
        userId: tUserId,
        file: mockXFile,
      ),
    );

    // assert
    verify(mockRepository.uploadAvatar(tUserId, mockXFile));
    expect(result, equals(const Right(tExpectedUrl)));
  });
}
