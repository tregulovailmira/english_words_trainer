import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/profile/domain/entities/profile_entity.dart';
import 'package:english_words_trainer/features/profile/domain/repositiroes/profile_repository.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/profile_repository_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late final GetProfile usecase;
  late final MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = GetProfile(mockRepository);
  });

  test('should return users profile via repository', () async {
    const userId = '123';
    final profile = ProfileEntity(
      id: userId,
      username: 'username',
      avatarUrl: 'avatarUrl.com',
      updatedAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
    );

    // arrange
    when(mockRepository.getProfileById(any))
        .thenAnswer((_) async => Right(profile));

    // act
    final result = await usecase(GetProfileParams(id: userId));

    // assert
    verify(mockRepository.getProfileById(userId));
    expect(result, equals(Right(profile)));
  });
}
