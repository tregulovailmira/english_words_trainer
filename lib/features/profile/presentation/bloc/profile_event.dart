part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class CreateProfileEvent extends ProfileEvent {
  final String userId;

  const CreateProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetProfileEvent extends ProfileEvent {
  final String userId;

  const GetProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final ProfileEntity profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object> get props => [profile];
}

class UploadAvatarEvent extends ProfileEvent {
  final XFile file;
  final String userId;

  const UploadAvatarEvent({
    required this.userId,
    required this.file,
  });
}
