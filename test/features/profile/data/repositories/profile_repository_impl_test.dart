import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/profile/data/datasources/profile_datasource.dart';
import 'package:english_words_trainer/features/profile/data/models/profile_model.dart';
import 'package:english_words_trainer/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:english_words_trainer/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './profile_repository_impl_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([ProfileDataSource])
void main() {
  late MockProfileDataSource mockProfileDataSource;
  late ProfileRepositoryImpl profileRepositoryImpl;

  const tUserId = '12345';
  const tDateString = '2022-07-18T13:48:37.491701Z';

  final tResponseFromDataSource = ProfileModel(
    id: tUserId,
    username: 'user-$tUserId',
    updatedAt: DateTime.parse(tDateString),
  );

  setUp(() {
    mockProfileDataSource = MockProfileDataSource();
    profileRepositoryImpl = ProfileRepositoryImpl(mockProfileDataSource);
  });

  group('createProfile', () {
    test(
      'should retrun ProfileEntity when creating profile was successful',
      () async {
        when(mockProfileDataSource.createProfile(any))
            .thenAnswer((_) async => tResponseFromDataSource);

        final result = await profileRepositoryImpl.createProfile(tUserId);

        verify(mockProfileDataSource.createProfile(tUserId));
        expect(result, equals(Right(tResponseFromDataSource.toDomain())));
      },
    );

    test('should return DataBaseFailure if creating profile was unsuccessful',
        () async {
      when(mockProfileDataSource.createProfile(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await profileRepositoryImpl.createProfile(tUserId);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('updateProfile', () {
    final tProfileForUpdate = ProfileEntity(
      id: tUserId,
      username: 'user-$tUserId',
      updatedAt: DateTime(2020, 10, 14),
    );
    test(
      'should retrun ProfileEntity when updating profile was successful',
      () async {
        when(mockProfileDataSource.updateProfile(any))
            .thenAnswer((_) async => tResponseFromDataSource);

        final result =
            await profileRepositoryImpl.updateProfile(tProfileForUpdate);

        verify(
          mockProfileDataSource
              .updateProfile(ProfileModel.fromDomain(tProfileForUpdate)),
        );
        expect(result, equals(Right(tResponseFromDataSource.toDomain())));
      },
    );

    test('should return DataBaseFailure if updating profile was unsuccessful',
        () async {
      when(mockProfileDataSource.updateProfile(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result =
          await profileRepositoryImpl.updateProfile(tProfileForUpdate);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('getProfile', () {
    test(
      'should retrun ProfileEntity when getting profile was successful',
      () async {
        when(mockProfileDataSource.getProfile(any))
            .thenAnswer((_) async => tResponseFromDataSource);

        final result = await profileRepositoryImpl.getProfileById(tUserId);

        verify(mockProfileDataSource.getProfile(tUserId));
        expect(result, equals(Right(tResponseFromDataSource.toDomain())));
      },
    );

    test('should return DataBaseFailure if creating profile was unsuccessful',
        () async {
      when(mockProfileDataSource.getProfile(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await profileRepositoryImpl.getProfileById(tUserId);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('uploadAvatar', () {
    const tAvatarUrl = 'testavatar.com';
    final tFileToUpload = readFile('avatar.jpg');
    final tDateTimeNow = DateTime.parse(tDateString);
    test(
      'should retrun uploaded avatar url when it was successful',
      () async {
        when(mockProfileDataSource.removeOldAvatarFromStorage(any))
            .thenAnswer((_) async => unit);

        when(
          mockProfileDataSource.uploadAvatarToStrorage(
            userId: anyNamed('userId'),
            fileName: anyNamed('fileName'),
            bytes: anyNamed('bytes'),
          ),
        ).thenAnswer((_) async => tAvatarUrl);

        when(
          mockProfileDataSource.updateAvatarUrlAtProfile(any, any),
        ).thenAnswer(
          (_) async => ProfileModel(
            id: tUserId,
            username: 'username',
            updatedAt: tDateTimeNow,
            avatarUrl: tAvatarUrl,
          ),
        );

        final result = await withClock(
          Clock.fixed(tDateTimeNow),
          () => profileRepositoryImpl.uploadAvatar(tUserId, tFileToUpload),
        );

        verify(mockProfileDataSource.removeOldAvatarFromStorage(tUserId));
        verify(
          mockProfileDataSource.uploadAvatarToStrorage(
            userId: anyNamed('userId'),
            fileName: anyNamed('fileName'),
            bytes: anyNamed('bytes'),
          ),
        );
        verify(
          mockProfileDataSource.updateAvatarUrlAtProfile(tUserId, tAvatarUrl),
        );
        expect(result, equals(const Right(tAvatarUrl)));
      },
    );

    test(
      'should return StorageFailure if removing old avatar was unsuccessful',
      () async {
        when(mockProfileDataSource.removeOldAvatarFromStorage(any))
            .thenThrow(StorageException('Storage error', '400'));
        final result = await profileRepositoryImpl.uploadAvatar(
          tUserId,
          tFileToUpload,
        );

        expect(
          result,
          equals(
            Left(
              StorageFailure(message: 'Storage error', statusCode: '400'),
            ),
          ),
        );
      },
    );

    test(
      'should return StorageFailure if uploading new avatar was unsuccessful',
      () async {
        when(mockProfileDataSource.removeOldAvatarFromStorage(any))
            .thenAnswer((_) async => unit);

        when(
          mockProfileDataSource.uploadAvatarToStrorage(
            userId: anyNamed('userId'),
            fileName: anyNamed('fileName'),
            bytes: anyNamed('bytes'),
          ),
        ).thenThrow(StorageException('Storage error', '400'));

        final result = await profileRepositoryImpl.uploadAvatar(
          tUserId,
          tFileToUpload,
        );

        expect(
          result,
          equals(
            Left(
              StorageFailure(message: 'Storage error', statusCode: '400'),
            ),
          ),
        );
      },
    );

    test(
      'should return DataBaseFailure if updating avatar url was unsuccessful',
      () async {
        when(mockProfileDataSource.removeOldAvatarFromStorage(any))
            .thenAnswer((_) async => unit);

        when(
          mockProfileDataSource.uploadAvatarToStrorage(
            userId: anyNamed('userId'),
            fileName: anyNamed('fileName'),
            bytes: anyNamed('bytes'),
          ),
        ).thenAnswer((_) async => tAvatarUrl);

        when(
          mockProfileDataSource.updateAvatarUrlAtProfile(any, any),
        ).thenThrow(
          DataBaseException('DB error', 400),
        );

        final result = await profileRepositoryImpl.uploadAvatar(
          tUserId,
          tFileToUpload,
        );

        expect(
          result,
          equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
        );
      },
    );
  });
}
