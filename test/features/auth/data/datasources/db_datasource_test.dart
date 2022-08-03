import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/auth/data/datasources/db_datasource.dart';
import 'package:english_words_trainer/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mocks/db_datasource_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
void main() {
  late MockSupabaseClient mockDbClient;
  late DbDataSourceImpl dbDataSourceImpl;
  late MockGoTrueClient goTrueClient;

  const email = 'test@test.com';
  const password = 'testPassword';

  setUp(() {
    mockDbClient = MockSupabaseClient();
    dbDataSourceImpl = DbDataSourceImpl(client: mockDbClient);
    goTrueClient = MockGoTrueClient();
  });

  group('sighInWithEmailAndPassword', () {
    void setUpSignInSuccessResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.signIn(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => GotrueSessionResponse(statusCode: 200));
    }

    void setUpSignInFailureResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.signIn(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => GotrueSessionResponse(
              statusCode: 400, error: GotrueError('DB error')));
    }

    test('should call signIn method of the Supabase client', () async {
      setUpSignInSuccessResponse();
      await dbDataSourceImpl.sighInWithEmailAndPassword(
          email: email, password: password);

      verify(goTrueClient.signIn(email: email, password: password));
      verifyNoMoreInteractions(goTrueClient);
    });

    test('should return unit if the response statusCode is 200', () async {
      setUpSignInSuccessResponse();
      final result = await dbDataSourceImpl.sighInWithEmailAndPassword(
          email: email, password: password);

      expect(result, equals(unit));
    });

    test('should throw DataBaseException when statusCode is not 200', () async {
      setUpSignInFailureResponse();
      final call = dbDataSourceImpl.sighInWithEmailAndPassword;

      expect(() => call(email: email, password: password),
          throwsA(const TypeMatcher<DataBaseException>()));
    });
  });

  group('signUp', () {
    void setUpSignUpSuccessResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.signUp(any, any))
          .thenAnswer((_) async => GotrueSessionResponse(statusCode: 200));
    }

    void setUpSignUpFailureResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.signUp(any, any)).thenAnswer((_) async =>
          GotrueSessionResponse(
              statusCode: 400, error: GotrueError('DB error')));
    }

    test('should call signUp method of the Supabase client', () async {
      setUpSignUpSuccessResponse();
      await dbDataSourceImpl.sighUp(email: email, password: password);

      verify(goTrueClient.signUp(email, password));
      verifyNoMoreInteractions(goTrueClient);
    });

    test('should return unit if the response statusCode is 200', () async {
      setUpSignUpSuccessResponse();
      final result =
          await dbDataSourceImpl.sighUp(email: email, password: password);

      expect(result, equals(unit));
    });

    test('should throw DataBaseException when statusCode is not 200', () async {
      setUpSignUpFailureResponse();
      final call = dbDataSourceImpl.sighUp;

      expect(() => call(email: email, password: password),
          throwsA(const TypeMatcher<DataBaseException>()));
    });
  });

  group('getSignedInUser', () {
    final tUser = User(
        id: '90674aec-d6cb-402f-b8da-0254e9425c43',
        appMetadata: {
          'provider': 'email',
          'providers': ['email']
        },
        userMetadata: {},
        aud: 'authenticated',
        email: 'megegi7024@storypo.com',
        phone: '123456',
        createdAt: '2022-07-18T13:48:37.491701Z',
        emailConfirmedAt: '2022-07-18T18:14:14.624729Z',
        phoneConfirmedAt: null,
        lastSignInAt: '2022-07-18T19:14:00.061656644Z',
        role: 'authenticated',
        updatedAt: '2022-07-18T19:14:00.065835Z');

    final tUserModel = UserModel.fromUserObject(tUser);

    void setUpUserSuccessResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.user()).thenReturn(tUser);
    }

    void setUpUserFailureResponse() {
      when(mockDbClient.auth).thenReturn(goTrueClient);
      when(goTrueClient.user()).thenReturn(null);
    }

    test('should call user method of the Supabase client', () async {
      setUpUserSuccessResponse();
      await dbDataSourceImpl.getSignedInUser();

      verify(goTrueClient.user());
      verifyNoMoreInteractions(goTrueClient);
    });

    test('should return UserModel if signed in user exists', () async {
      setUpUserSuccessResponse();
      final result = await dbDataSourceImpl.getSignedInUser();

      expect(result, equals(tUserModel));
    });

    test('should return null if signed in user doesn\'t exists', () async {
      setUpUserFailureResponse();
      final result = await dbDataSourceImpl.getSignedInUser();

      expect(result, null);
    });
  });
}
