part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String? errorMessage;
  final bool isError;
  final bool isLoading;
  final bool isLoadingAvatar;
  final ProfileEntity? profile;

  const ProfileState({
    this.errorMessage,
    this.isError = false,
    this.isLoading = false,
    this.isLoadingAvatar = false,
    this.profile,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        isLoading,
        isLoadingAvatar,
        isError,
        profile,
      ];
}
