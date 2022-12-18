import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import './camera_button.dart';

class Camera extends StatelessWidget {
  const Camera({
    required this.changeCameraDirection,
    required this.onCreatePhoto,
    required this.cameraController,
    Key? key,
  }) : super(key: key);

  final Function() changeCameraDirection;
  final Function() onCreatePhoto;
  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraPreview(cameraController),
        GestureDetector(
          onTap: changeCameraDirection,
          child: const CameraButton(
            icon: Icons.flip_camera_ios_outlined,
          ),
        ),
        GestureDetector(
          onTap: onCreatePhoto,
          child: const CameraButton(
            alignment: Alignment.bottomCenter,
            icon: Icons.camera_alt_outlined,
          ),
        ),
      ],
    );
  }
}
