import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:english_words_trainer/features/auth/data/models/user_model.dart';
import 'package:english_words_trainer/features/auth/domain/entities/user_entity.dart';

void main() {
  test(
    'should be a subclass of UserEntity entity',
    () async {
      const userModel = UserModel(
          id: '90674aec-d6cb-402f-b8da-0254e9425c43',
          email: 'megegi7024@storypo.com',
          phone: '123456');
      expect(userModel, isA<UserEntity>());
    },
  );

  test(
    'should return a valid model when all neccessary fields exists',
    () async {
      final tUser = User(
          id: "90674aec-d6cb-402f-b8da-0254e9425c43",
          appMetadata: {
            "provider": "email",
            "providers": ["email"]
          },
          userMetadata: {},
          aud: "authenticated",
          email: "megegi7024@storypo.com",
          phone: "123456",
          createdAt: "2022-07-18T13:48:37.491701Z",
          emailConfirmedAt: "2022-07-18T18:14:14.624729Z",
          phoneConfirmedAt: null,
          lastSignInAt: "2022-07-18T19:14:00.061656644Z",
          role: "authenticated",
          updatedAt: "2022-07-18T19:14:00.065835Z");

      const expectedUserModel = UserModel(
          id: '90674aec-d6cb-402f-b8da-0254e9425c43',
          email: 'megegi7024@storypo.com',
          phone: '123456');

      final result = UserModel.fromUserObject(tUser);

      expect(result, equals(expectedUserModel));
    },
  );
}
