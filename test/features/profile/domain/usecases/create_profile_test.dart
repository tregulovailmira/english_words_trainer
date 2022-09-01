import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/profile/domain/entities/profile_entity.dart';
import 'package:english_words_trainer/features/profile/domain/repositiroes/profile_repository.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/create_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/profile_repository_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late final CreateProfile usecase;
  late final MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = CreateProfile(mockRepository);
  });

  test('should return users profile via repository', () async {
    const tUserId = '123';
    final tCreatedProfile = ProfileEntity(
      id: tUserId,
      username: '',
      updatedAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
    );

    // arrange
    when(mockRepository.createProfile(any))
        .thenAnswer((_) async => Right(tCreatedProfile));

    // act
    final result = await usecase(CreateProfileParams(userId: tUserId));

    // assert
    verify(mockRepository.createProfile(tUserId));
    expect(result, equals(Right(tCreatedProfile)));
  });
}
