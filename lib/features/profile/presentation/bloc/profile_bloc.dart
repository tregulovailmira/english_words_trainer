import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/create_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_avatar.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CreateProfile createProfile;
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UploadAvatar uploadAvatar;

  ProfileBloc({
    required this.createProfile,
    required this.getProfile,
    required this.updateProfile,
    required this.uploadAvatar,
  }) : super(const ProfileState()) {
    on<CreateProfileEvent>((event, emit) async {
      emit(const ProfileState(isLoading: true));

      emit(
        await _getResultOrFailure(
          event: event,
          usecase: createProfile,
          params: CreateProfileParams(userId: event.userId),
        ),
      );
    });
    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileState(isLoading: true, profile: state.profile));

      emit(
        await _getResultOrFailure(
          event: event,
          usecase: updateProfile,
          params: UpdateProfileParams(profile: event.profile),
        ),
      );
    });
    on<GetProfileEvent>((event, emit) async {
      emit(const ProfileState(isLoading: true));

      emit(
        await _getResultOrFailure(
          event: event,
          usecase: getProfile,
          params: GetProfileParams(id: event.userId),
        ),
      );

      if (state.profile == null && !state.isError) {
        add(CreateProfileEvent(event.userId));
      }
    });
    on<UploadAvatarEvent>((event, emit) async {
      emit(ProfileState(isLoadingAvatar: true, profile: state.profile));

      emit(
        await _getResultOrFailure(
          event: event,
          usecase: uploadAvatar,
          params: UploadAvatarParams(
            userId: event.userId,
            file: event.file,
          ),
        ),
      );
    });
  }

  Future<ProfileState> _getResultOrFailure({
    required Usecase usecase,
    required ProfileEvent event,
    required params,
  }) async {
    final profileOrFailure = await usecase(params);
    return profileOrFailure.fold(
      (failure) => _getFailure(failure),
      (result) => _getResult(event, result),
    );
  }

  ProfileState _getFailure(Failure failure) {
    return ProfileState(
      isError: true,
      errorMessage: _mapFailureToMessage(failure),
      profile: state.profile,
    );
  }

  ProfileState _getResult(ProfileEvent event, dynamic result) {
    ProfileEntity profile;
    switch (event.runtimeType) {
      case UploadAvatarEvent:
        profile = ProfileEntity(
          id: state.profile!.id,
          username: state.profile!.username,
          avatarUrl: result,
          updatedAt: state.profile!.updatedAt,
        );
        return ProfileState(profile: profile);
      default:
        return ProfileState(profile: result);
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DataBaseFailure:
        return (failure as DataBaseFailure).message;
      case StorageFailure:
        return (failure as StorageFailure).message;

      default:
        return 'Unexpected Error';
    }
  }
}
