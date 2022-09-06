import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  AuthRequiredState<Profile> createState() => _ProfileState();
}

class _ProfileState extends AuthRequiredState<Profile> {
  String userId = '';

  @override
  void onAuthenticated(Session session) async {
    final user = session.user;
    if (user != null && userId.isEmpty) {
      setState(() {
        userId = user.id;
      });
      context.read<ProfileBloc>().add(GetProfileEvent(userId));
    }
  }

  void onLogOut() {
    context.read<AuthBloc>().add(SignOutEvent());
  }

  void onUpdateProfile(String username) {
    final profile = context.read<ProfileBloc>().state.profile!;
    final preparedProfile = ProfileEntity(
      id: profile.id,
      username: username,
      updatedAt: profile.updatedAt,
      avatarUrl: profile.avatarUrl,
    );
    context.read<ProfileBloc>().add(UpdateProfileEvent(preparedProfile));
    FocusScope.of(context).unfocus();
  }

  void onUploadAvatar(XFile imageFile) {
    context
        .read<ProfileBloc>()
        .add(UploadAvatarEvent(userId: userId, file: imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (BuildContext context, state) {
          if (state.isError) {
            context.showErrorSnackBar(message: state.errorMessage!);
          }
        },
        builder: (BuildContext context, state) {
          if (state.profile == null) {
            return Center(
              child: ProgressCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            );
          }
          return ProfileWidget(
            userId: userId,
            onLogOut: onLogOut,
            onUpdateProfile: onUpdateProfile,
            onUploadAvatar: onUploadAvatar,
            profile: state.profile!,
            isLoading: state.isLoading,
            isLoadingAvatar: state.isLoadingAvatar,
          );
        },
      ),
    );
  }
}
