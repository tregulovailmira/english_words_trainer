import 'package:clock/clock.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/profile/data/datasources/profile_datasource.dart';
import 'package:english_words_trainer/features/profile/data/models/profile_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './profile_datasource_test.mocks.dart';

@GenerateMocks([
  SupabaseClient,
  SupabaseQueryBuilder,
  PostgrestBuilder,
  PostgrestFilterBuilder,
])
void main() {
  dotenv.testLoad(fileInput: "PROFILES_TABLE_NAME='profiles'");

  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockSupabaseQueryBuilder;
  late MockPostgrestBuilder mockPostgrestBuilder;
  late MockPostgrestFilterBuilder postgrestFilterBuilder;
  late ProfileDataSourceImpl profileDataSourceImpl;

  const tUserId = '1234';
  const tDateString = '2022-07-18T13:48:37.491701Z';
  final tProfile = {
    'id': tUserId,
    'username': 'username-$tUserId',
    'updatedAt': tDateString,
    'avatarUrl': null,
  };
  final tProfileModel = ProfileModel.fromJson(tProfile);

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseQueryBuilder = MockSupabaseQueryBuilder();
    mockPostgrestBuilder = MockPostgrestBuilder();
    postgrestFilterBuilder = MockPostgrestFilterBuilder();

    profileDataSourceImpl = ProfileDataSourceImpl(mockSupabaseClient);
  });

  group('createProfile', () {
    const tProfileForCreating = {'id': tUserId, 'username': 'user-$tUserId'};

    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.insert(any))
          .thenReturn(mockPostgrestBuilder);
      when(mockPostgrestBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: [tProfile],
          status: 201,
        ),
      );
    }

    void setUpFailureResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.insert(any))
          .thenReturn(mockPostgrestBuilder);
      when(mockPostgrestBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test(
      'should call insert method of the Supabase client ',
      () async {
        // arrange
        setUpSuccessfullResponse();

        // act
        profileDataSourceImpl.createProfile(tUserId);

        // assert
        verify(mockSupabaseClient.from('profiles'));
        verify(mockSupabaseQueryBuilder.insert(tProfileForCreating));
        verify(mockPostgrestBuilder.execute());
        verifyNoMoreInteractions(mockSupabaseClient);
        verifyNoMoreInteractions(mockSupabaseQueryBuilder);
        verifyNoMoreInteractions(mockPostgrestBuilder);
      },
    );

    test(
      'should return ProfileModel when creating profile was successful',
      () async {
        setUpSuccessfullResponse();
        final result = await profileDataSourceImpl.createProfile(tUserId);
        expect(result, equals(tProfileModel));
      },
    );

    test(
      'should return DataBaseException when status code is not 201',
      () async {
        setUpFailureResponse();

        final call = profileDataSourceImpl.createProfile;

        expect(
          () async => call(tUserId),
          throwsA(const TypeMatcher<DataBaseException>()),
        );
      },
    );
  });

  group('updateProfile', () {
    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.update(any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.match(any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: [tProfile],
          status: 200,
        ),
      );
    }

    void setUpFailureResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.update(any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.match(any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test(
      'should call update method of the Supabase client ',
      () async {
        // arrange
        setUpSuccessfullResponse();

        // act
        withClock(
          Clock.fixed(DateTime.parse(tDateString)),
          () => profileDataSourceImpl.updateProfile(tProfileModel),
        );

        // assert
        verify(mockSupabaseClient.from('profiles'));
        verify(
          mockSupabaseQueryBuilder.update({
            'username': 'username-$tUserId',
            'updatedAt': tDateString,
          }),
        );
        verify(postgrestFilterBuilder.match({'id': tUserId}));
        verify(postgrestFilterBuilder.execute());
        verifyNoMoreInteractions(mockSupabaseClient);
        verifyNoMoreInteractions(mockSupabaseQueryBuilder);
        verifyNoMoreInteractions(postgrestFilterBuilder);
      },
    );

    test(
      'should return ProfileModel when updating profile was successful',
      () async {
        // arrange
        final tUpdatedProfile = ProfileModel(
          id: tProfileModel.id,
          username: tProfileModel.username,
          updatedAt: DateTime.parse(tDateString),
        );
        setUpSuccessfullResponse();

        // act
        final result = await withClock(
          Clock.fixed(DateTime.parse(tDateString)),
          () => profileDataSourceImpl.updateProfile(tProfileModel),
        );
        // assert

        expect(result, equals(tUpdatedProfile));
      },
    );

    test(
      'should return DataBaseException when status code is not 200',
      () async {
        setUpFailureResponse();

        final call = profileDataSourceImpl.updateProfile;

        expect(
          () async => call(tProfileModel),
          throwsA(const TypeMatcher<DataBaseException>()),
        );
      },
    );
  });

  group('getProfile', () {
    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.select())
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.eq(any, any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: [tProfile],
          status: 200,
        ),
      );
    }

    void setUpFailureResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.select())
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.eq(any, any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test(
      'should call select method of the Supabase client ',
      () async {
        // arrange
        setUpSuccessfullResponse();

        // act
        profileDataSourceImpl.getProfile(tUserId);
        // assert
        verify(mockSupabaseClient.from('profiles'));
        verify(mockSupabaseQueryBuilder.select());
        verify(postgrestFilterBuilder.eq('id', tUserId));
        verify(postgrestFilterBuilder.execute());
        verifyNoMoreInteractions(mockSupabaseClient);
        verifyNoMoreInteractions(mockSupabaseQueryBuilder);
        verifyNoMoreInteractions(postgrestFilterBuilder);
      },
    );

    test(
      'should return ProfileModel when getting profile was successful',
      () async {
        // arrange
        setUpSuccessfullResponse();

        // act
        final result = await profileDataSourceImpl.getProfile(tUserId);
        // assert

        expect(result, equals(tProfileModel));
      },
    );

    test(
      'should return DataBaseException when status code is not 200',
      () async {
        setUpFailureResponse();

        final call = profileDataSourceImpl.getProfile;

        expect(
          () async => call(tUserId),
          throwsA(const TypeMatcher<DataBaseException>()),
        );
      },
    );
  });
}
