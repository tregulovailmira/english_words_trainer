import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import './image_source_selection.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/camera/camera_bloc.dart';
import '../pages/custom_camera.dart';

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final void Function(XFile) onUpload;
  final bool isLoading;

  const Avatar({
    required this.imageUrl,
    required this.onUpload,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  Future<void> Function() onGalleryChosen(context) => () async {
        final imageFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (imageFile == null) {
          return;
        }

        onUpload(imageFile);
        Navigator.of(context).pop();
      };

  void Function() onCameraChosen(context) => () {
        Navigator.of(context).push(
          MaterialPageRoute<Widget>(
            fullscreenDialog: true,
            builder: (context) => BlocProvider<CameraBloc>(
              create: (context) => di.sl<CameraBloc>(),
              child: CustomCamera(
                onUploadPhoto: onUpload,
              ),
            ),
          ),
        );
      };

  void Function() chooseSourceOfPicture(BuildContext context) => () {
        showDialog(
          context: context,
          builder: (_) => ImageSourceSelection(
            onGallerySelect: onGalleryChosen(context),
            onCameraSelect: onCameraChosen(context),
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.loose,
        children: [
          if (imageUrl == null)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 75,
              child: const Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.white,
              ),
            )
          else
            CircleAvatar(
              radius: 75,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: NetworkImage(imageUrl!),
            ),
          FloatingActionButton(
            mini: true,
            onPressed: isLoading ? null : chooseSourceOfPicture(context),
            child: isLoading
                ? const ProgressCircle()
                : const Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }
}
