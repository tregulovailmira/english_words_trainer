import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import './avatar.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../bloc/profile_bloc.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.usernameController,
    required this.onUpdateProfile,
    required this.onUploadAvatar,
    Key? key,
  }) : super(key: key);
  final TextEditingController usernameController;
  final void Function() onUpdateProfile;
  final void Function(XFile) onUploadAvatar;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      widget.usernameController.text = profile.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Avatar(
              imageUrl: state.profile!.avatarUrl,
              onUpload: widget.onUploadAvatar,
              isLoading: state.isLoadingAvatar,
            ),
            TextFormField(
              controller: widget.usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                contentPadding: EdgeInsets.all(5),
              ),
            ),
            Text(
              'Last update was ${state.profile!.updatedAt.formatDate()}',
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
                onPressed: state.isLoading || state.isLoadingAvatar
                    ? null
                    : widget.onUpdateProfile,
                child: state.isLoading
                    ? const ProgressCircle()
                    : const Text('Update Profile'),
              ),
            )
          ],
        );
      },
    );
  }
}
