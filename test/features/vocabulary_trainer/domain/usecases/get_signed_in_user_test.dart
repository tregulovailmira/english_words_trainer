import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/vocabulary_trainer/domain/repositories/auth_repository.dart';
import 'package:english_words_trainer/features/vocabulary_trainer/domain/usecases/get_signed_in_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.mocks.dart';

@GenerateMocks([AuthRepositry])
void main() {
  late MockAuthRepositry mockAuthRepository;
  late GetSignedInUser usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepositry();
    usecase = GetSignedInUser(mockAuthRepository);
  });

  test('should get signed in user via repository', () async {
    final user = User(
        id: "90674aec-d6cb-402f-b8da-0254e9425c43",
        appMetadata: {
          "provider": "email",
          "providers": ["email"]
        },
        userMetadata: {},
        aud: "authenticated",
        email: "megegi7024@storypo.com",
        phone: "",
        createdAt: "2022-07-18T13:48:37.491701Z",
        emailConfirmedAt: "2022-07-18T18:14:14.624729Z",
        phoneConfirmedAt: null,
        lastSignInAt: "2022-07-18T19:14:00.061656644Z",
        role: "authenticated",
        updatedAt: "2022-07-18T19:14:00.065835Z");

    when(mockAuthRepository.getSignedInUser())
        .thenAnswer((_) async => Right(user));
    final result = await usecase(NoParams());
    expect(result, equals(Right(user)));
    verify(mockAuthRepository.getSignedInUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
