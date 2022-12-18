import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel implements _$ProfileModel {
  const ProfileModel._();

  factory ProfileModel({
    required String id,
    required String username,
    required DateTime updatedAt,
    String? avatarUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromDomain(ProfileEntity profile) {
    return ProfileModel(
      id: profile.id,
      username: profile.username,
      updatedAt: profile.updatedAt.toUtc(),
      avatarUrl: profile.avatarUrl,
    );
  }

  ProfileEntity toDomain() {
    return ProfileEntity(
      id: id,
      username: username,
      updatedAt: updatedAt.toLocal(),
      avatarUrl: avatarUrl,
    );
  }
}
