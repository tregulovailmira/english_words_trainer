import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/auth/domain/entities/user_entity.dart';
import 'package:english_words_trainer/features/auth/domain/repositories/auth_repository.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/get_signed_in_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepositry mockAuthRepository;
  late GetSignedInUser usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepositry();
    usecase = GetSignedInUser(mockAuthRepository);
  });

  test('should get signed in user via repository', () async {
    const user = UserEntity(
      id: "90674aec-d6cb-402f-b8da-0254e9425c43",
      email: "megegi7024@storypo.com",
      phone: "",
    );
    when(mockAuthRepository.getSignedInUser())
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(NoParams());
    expect(result, equals(const Right(user)));
    verify(mockAuthRepository.getSignedInUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
