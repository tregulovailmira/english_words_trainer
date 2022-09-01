import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import 'log_out_button.dart';
import 'profile_form.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({required this.userId, required this.onLogOut, Key? key})
      : super(key: key);

  final String userId;
  final void Function() onLogOut;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final usernameController = TextEditingController(text: '-');

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent(widget.userId));
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  void onUpdateProfile() {
    final profile = context.read<ProfileBloc>().state.profile!;
    final preparedProfile = ProfileEntity(
      id: profile.id,
      username: usernameController.text,
      updatedAt: profile.updatedAt,
      avatarUrl: profile.avatarUrl,
    );
    context.read<ProfileBloc>().add(UpdateProfileEvent(preparedProfile));
    FocusScope.of(context).unfocus();
  }

  void onUploadAvatar(XFile imageFile) {
    context
        .read<ProfileBloc>()
        .add(UploadAvatarEvent(userId: widget.userId, file: imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (BuildContext context, state) {
        if (state.isError) {
          context.showErrorSnackBar(message: state.errorMessage!);
        }
      },
      builder: (BuildContext context, state) {
        if (state.profile != null) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: ProfileForm(
                  usernameController: usernameController,
                  onUpdateProfile: onUpdateProfile,
                  onUploadAvatar: onUploadAvatar,
                ),
              ),
              Divider(
                color: Colors.red.shade300,
                height: 50,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogOutButton(
                    onPressed: widget.onLogOut,
                  ),
                ],
              )
            ],
          );
        }
        if (state.isLoading) {
          return Center(
            child: ProgressCircle(
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
