import 'dart:io';

import 'package:flutter/material.dart';

import './camera_button.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    required this.photo,
    required this.cancelMadePhoto,
    required this.uploadPhoto,
    Key? key,
  }) : super(key: key);

  final File photo;
  final Function() cancelMadePhoto;
  final Function() uploadPhoto;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(photo),
        GestureDetector(
          onTap: cancelMadePhoto,
          child: const CameraButton(
            icon: Icons.turn_left,
          ),
        ),
        GestureDetector(
          onTap: uploadPhoto,
          child: const CameraButton(
            alignment: Alignment.bottomRight,
            icon: Icons.check,
          ),
        ),
      ],
    );
  }
}
