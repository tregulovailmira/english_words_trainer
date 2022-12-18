import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './avatar.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    required this.profile,
    required this.usernameController,
    required this.onUpdateProfile,
    required this.onUploadAvatar,
    required this.isLoading,
    required this.isLoadingAvatar,
    Key? key,
  }) : super(key: key);

  final ProfileEntity profile;
  final TextEditingController usernameController;
  final void Function() onUpdateProfile;
  final void Function(XFile) onUploadAvatar;
  final bool isLoading;
  final bool isLoadingAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Avatar(
          imageUrl: profile.avatarUrl,
          onUpload: onUploadAvatar,
          isLoading: isLoadingAvatar,
        ),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            contentPadding: EdgeInsets.all(5),
          ),
        ),
        Text(
          'Last update was ${profile.updatedAt.formatDate()}',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: isLoading || isLoadingAvatar ? null : onUpdateProfile,
            child: isLoading
                ? const ProgressCircle()
                : const Text('Update Profile'),
          ),
        )
      ],
    );
  }
}
