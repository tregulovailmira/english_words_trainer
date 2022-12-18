import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './log_out_button.dart';
import './profile_form.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    required this.userId,
    required this.onLogOut,
    required this.onUpdateProfile,
    required this.onUploadAvatar,
    required this.profile,
    required this.isLoading,
    required this.isLoadingAvatar,
    Key? key,
  }) : super(key: key);

  final String userId;
  final void Function() onLogOut;
  final void Function(String) onUpdateProfile;
  final void Function(XFile) onUploadAvatar;
  final ProfileEntity profile;
  final bool isLoading;
  final bool isLoadingAvatar;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.profile.username);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  onUpdateProfile() {
    widget.onUpdateProfile(usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: ProfileForm(
            profile: widget.profile,
            isLoading: widget.isLoading,
            isLoadingAvatar: widget.isLoadingAvatar,
            usernameController: usernameController,
            onUpdateProfile: onUpdateProfile,
            onUploadAvatar: widget.onUploadAvatar,
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
}
