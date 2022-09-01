import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/profile/domain/entities/profile_entity.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/create_profile.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/get_profile.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/update_profile.dart';
import 'package:english_words_trainer/features/profile/domain/usecases/upload_avatar.dart';
import 'package:english_words_trainer/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './mocks/profile_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProfile,
  GetProfile,
  UpdateProfile,
  UploadAvatar,
  XFile,
])
void main() {
  late MockCreateProfile mockCreateProfile;
  late MockGetProfile mockGetProfile;
  late MockUpdateProfile mockUpdateProfile;
  late MockUploadAvatar mockUploadAvatar;
  late MockXFile mockXFile;

  late ProfileBloc profileBloc;

  setUp(() {
    mockCreateProfile = MockCreateProfile();
    mockGetProfile = MockGetProfile();
    mockUpdateProfile = MockUpdateProfile();
    mockUploadAvatar = MockUploadAvatar();
    mockXFile = MockXFile();
    profileBloc = ProfileBloc(
      createProfile: mockCreateProfile,
      getProfile: mockGetProfile,
      updateProfile: mockUpdateProfile,
      uploadAvatar: mockUploadAvatar,
    );
  });

  const tUserId = '1234';
  final tProfile = ProfileEntity(
    id: tUserId,
    username: 'user-$tUserId',
    updatedAt: DateTime(2020, 10, 14),
  );

  final expectedSuccessStates = [
    const ProfileState(isLoading: true),
    ProfileState(profile: tProfile),
  ];

  final expectedFailureStates = [
    const ProfileState(isLoading: true),
    const ProfileState(
      isError: true,
      errorMessage: 'DB error',
    ),
  ];

  test('initial state should be empty', () {
    expect(profileBloc.state, equals(const ProfileState()));
  });

  group(
    'create profile',
    () {
      test(
        'should create profile via usecase',
        () async {
          when(mockCreateProfile(any)).thenAnswer((_) async => Right(tProfile));

          expectLater(profileBloc.stream, emitsInOrder(expectedSuccessStates));

          profileBloc.add(const CreateProfileEvent(tUserId));
        },
      );

      test(
        'should emit error when creating profile was unsuccessfil',
        () async {
          when(mockCreateProfile(any)).thenAnswer(
            (_) async => Left(
              DataBaseFailure(message: 'DB error'),
            ),
          );

          expectLater(profileBloc.stream, emitsInOrder(expectedFailureStates));

          profileBloc.add(const CreateProfileEvent(tUserId));
        },
      );
    },
  );

  group(
    'get profile',
    () {
      test(
        'should get profile via usecase',
        () async {
          when(mockGetProfile(any)).thenAnswer((_) async => Right(tProfile));

          expectLater(profileBloc.stream, emitsInOrder(expectedSuccessStates));

          profileBloc.add(const GetProfileEvent(tUserId));
        },
      );

      test(
        'should emit error when getting profile was unsuccessfil',
        () async {
          when(mockGetProfile(any)).thenAnswer(
            (_) async => Left(
              DataBaseFailure(message: 'DB error'),
            ),
          );

          expectLater(profileBloc.stream, emitsInOrder(expectedFailureStates));

          profileBloc.add(const GetProfileEvent(tUserId));
        },
      );

      test(
        'should create profile if it doesn\'t exist',
        () async {
          when(mockGetProfile(any)).thenAnswer((_) async => const Right(null));
          when(mockCreateProfile(any)).thenAnswer((_) async => Right(tProfile));

          final expectedStates = [
            const ProfileState(isLoading: true),
            const ProfileState(),
            const ProfileState(isLoading: true),
            ProfileState(profile: tProfile),
          ];
          expectLater(profileBloc.stream, emitsInOrder(expectedStates));

          profileBloc.add(const GetProfileEvent(tUserId));
        },
      );
    },
  );

  group(
    'update profile',
    () {
      test(
        'should update profile via usecase',
        () async {
          when(mockUpdateProfile(any)).thenAnswer((_) async => Right(tProfile));

          expectLater(profileBloc.stream, emitsInOrder(expectedSuccessStates));

          profileBloc.add(UpdateProfileEvent(tProfile));
        },
      );

      test(
        'should emit error when updating profile was unsuccessfil',
        () async {
          when(mockUpdateProfile(any)).thenAnswer(
            (_) async => Left(
              DataBaseFailure(message: 'DB error'),
            ),
          );

          expectLater(profileBloc.stream, emitsInOrder(expectedFailureStates));

          profileBloc.add(UpdateProfileEvent(tProfile));
        },
      );
    },
  );

  group(
    'upload avatar',
    () {
      const tAvatarUrl = 'https://testavatar.com';
      test(
        'should upload avatar via usecase',
        () async {
          final updatedProfile = ProfileEntity(
            id: tProfile.id,
            username: tProfile.username,
            updatedAt: tProfile.updatedAt,
            avatarUrl: tAvatarUrl,
          );
          final expectedSuccessStates = [
            const ProfileState(isLoading: true),
            ProfileState(profile: tProfile),
            ProfileState(isLoadingAvatar: true, profile: tProfile),
            ProfileState(profile: updatedProfile),
          ];
          when(mockUploadAvatar(any)).thenAnswer(
            (_) async => const Right(tAvatarUrl),
          );
          when(mockGetProfile(any)).thenAnswer((_) async => Right(tProfile));

          expectLater(profileBloc.stream, emitsInOrder(expectedSuccessStates));

          profileBloc.add(const GetProfileEvent(tUserId));
          profileBloc.add(UploadAvatarEvent(userId: tUserId, file: mockXFile));
        },
      );

      test(
        'should emit error when uploading avatar was unsuccessfil',
        () async {
          when(mockUploadAvatar(any)).thenAnswer(
            (_) async => Left(
              StorageFailure(message: 'Storage error'),
            ),
          );
          when(mockGetProfile(any)).thenAnswer((_) async => Right(tProfile));

          final expectedFailureStates = [
            const ProfileState(isLoading: true),
            ProfileState(profile: tProfile),
            ProfileState(isLoadingAvatar: true, profile: tProfile),
            ProfileState(isError: true, errorMessage: 'Storage error', profile: tProfile),
          ];

          expectLater(profileBloc.stream, emitsInOrder(expectedFailureStates));
          profileBloc.add(const GetProfileEvent(tUserId));
          profileBloc.add(UploadAvatarEvent(userId: tUserId, file: mockXFile));
        },
      );
    },
  );
}
