import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/profile/domain/entities/profile_entity.dart';
import 'package:english_words_trainer/features/profile/domain/repositiroes/profile_repository.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/update_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './update_profile_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late final UpdateProfile usecase;
  late final MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdateProfile(mockRepository);
  });

  test('should return users profile via repository', () async {
    const tUserId = '123';
    final tProfile = ProfileEntity(
      id: tUserId,
      username: '',
      updatedAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
    );

    // arrange
    when(mockRepository.updateProfile(any))
        .thenAnswer((_) async => Right(tProfile));

    // act
    final result = await usecase(UpdateProfileParams(profile: tProfile));

    // assert
    verify(mockRepository.updateProfile(tProfile));
    expect(result, equals(Right(tProfile)));
  });
}
