import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

final tableName = dotenv.env['PROFILES_TABLE_NAME']!;
final storageName = dotenv.env['STORAGE_NAME']!;

abstract class ProfileDataSource {
  Future<ProfileModel> createProfile(String userId);
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile(String userId);
  Future<String> uploadAvatarToStrorage({
    required String userId,
    required String fileName,
    required Uint8List bytes,
  });
  Future<Unit> removeOldAvatarFromStorage(String userId);
  Future<ProfileModel> updateAvatarUrlAtProfile(
    String userId,
    String avatarUrl,
  );
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final SupabaseClient client;

  ProfileDataSourceImpl(this.client);

  @override
  Future<ProfileModel> createProfile(String userId) async {
    final profileForCreating = {
      'id': userId,
      'username': 'user-$userId',
    };
    final result =
        await client.from(tableName).insert(profileForCreating).execute();
    _handleError(result, 201);
    return ProfileModel.fromJson((result.data as List).first);
  }

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    final result =
        await client.from(tableName).select().eq('id', userId).execute();
    _handleError(result, 200);
    if ((result.data as List).isNotEmpty) {
      return ProfileModel.fromJson((result.data as List).first);
    }
    return null;
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final result = await client.from(tableName).update({
      'username': profile.username,
      'updatedAt': clock.now().toUtc().toIso8601String(),
    }).match({'id': profile.id}).execute();
    _handleError(result, 200);
    return ProfileModel.fromJson((result.data as List).first);
  }

  @override
  Future<String> uploadAvatarToStrorage({
    required String userId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final folderName = 'user-$userId';
    final filePath = '$folderName/$fileName';

    final response =
        await client.storage.from(storageName).uploadBinary(filePath, bytes);
    _handleStorageError(response);

    final imageUrlResponse =
        client.storage.from(storageName).getPublicUrl(filePath);
    _handleStorageError(imageUrlResponse);

    return imageUrlResponse.data!;
  }

  @override
  Future<Unit> removeOldAvatarFromStorage(String userId) async {
    try {
      final avatarFolder = 'user-$userId';
      final folderContent = await Supabase.instance.client.storage
          .from(storageName)
          .list(path: avatarFolder);
      _handleStorageError(folderContent);

      final fileName = folderContent.data!.isNotEmpty
          ? folderContent.data!.first.name
          : null;
      if (fileName != null) {
        final response = await client.storage
            .from(storageName)
            .remove(['$avatarFolder/$fileName']);
        _handleStorageError(response);
      }

      return unit;
    } on StorageException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ProfileModel> updateAvatarUrlAtProfile(
    String userId,
    String avatarUrl,
  ) async {
    final result = await client.from(tableName).update({
      'avatarUrl': avatarUrl,
      'updatedAt': clock.now().toUtc().toIso8601String(),
    }).match({'id': userId}).execute();
    _handleError(result, 200);
    return ProfileModel.fromJson((result.data as List).first);
  }

  _handleError(result, expectedStatus) {
    if (result.status != expectedStatus) {
      throw DataBaseException(
        result.error!.message,
        result.status,
      );
    }
  }

  _handleStorageError(StorageResponse response) {
    if (response.error != null) {
      throw StorageException(
        response.error!.message,
        response.error?.statusCode,
      );
    }
  }
}
