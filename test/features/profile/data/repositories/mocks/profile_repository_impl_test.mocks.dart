// Mocks generated by Mockito 5.2.0 from annotations
// in english_words_trainer/test/features/profile/data/repositories/profile_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;
import 'dart:typed_data' as _i6;

import 'package:dartz/dartz.dart' as _i3;
import 'package:english_words_trainer/features/profile/data/datasources/profile_datasource.dart'
    as _i4;
import 'package:english_words_trainer/features/profile/data/models/profile_model.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeProfileModel_0 extends _i1.Fake implements _i2.ProfileModel {}

class _FakeUnit_1 extends _i1.Fake implements _i3.Unit {}

/// A class which mocks [ProfileDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockProfileDataSource extends _i1.Mock implements _i4.ProfileDataSource {
  MockProfileDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.ProfileModel> createProfile(String? userId) =>
      (super.noSuchMethod(Invocation.method(#createProfile, [userId]),
              returnValue:
                  Future<_i2.ProfileModel>.value(_FakeProfileModel_0()))
          as _i5.Future<_i2.ProfileModel>);
  @override
  _i5.Future<_i2.ProfileModel> updateProfile(_i2.ProfileModel? profile) =>
      (super.noSuchMethod(Invocation.method(#updateProfile, [profile]),
              returnValue:
                  Future<_i2.ProfileModel>.value(_FakeProfileModel_0()))
          as _i5.Future<_i2.ProfileModel>);
  @override
  _i5.Future<_i2.ProfileModel?> getProfile(String? userId) =>
      (super.noSuchMethod(Invocation.method(#getProfile, [userId]),
              returnValue: Future<_i2.ProfileModel?>.value())
          as _i5.Future<_i2.ProfileModel?>);
  @override
  _i5.Future<String> uploadAvatarToStrorage(
          {String? userId, String? fileName, _i6.Uint8List? bytes}) =>
      (super.noSuchMethod(
          Invocation.method(#uploadAvatarToStrorage, [],
              {#userId: userId, #fileName: fileName, #bytes: bytes}),
          returnValue: Future<String>.value('')) as _i5.Future<String>);
  @override
  _i5.Future<_i3.Unit> removeOldAvatarFromStorage(String? userId) =>
      (super.noSuchMethod(
              Invocation.method(#removeOldAvatarFromStorage, [userId]),
              returnValue: Future<_i3.Unit>.value(_FakeUnit_1()))
          as _i5.Future<_i3.Unit>);
  @override
  _i5.Future<_i2.ProfileModel> updateAvatarUrlAtProfile(
          String? userId, String? avatarUrl) =>
      (super.noSuchMethod(
              Invocation.method(#updateAvatarUrlAtProfile, [userId, avatarUrl]),
              returnValue:
                  Future<_i2.ProfileModel>.value(_FakeProfileModel_0()))
          as _i5.Future<_i2.ProfileModel>);
}
