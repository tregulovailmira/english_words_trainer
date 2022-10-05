import 'package:flutter/material.dart';

import './source_selection_option.dart';

class ImageSourceSelection extends StatelessWidget {
  const ImageSourceSelection({
    required this.onGallerySelect,
    required this.onCameraSelect,
    Key? key,
  }) : super(key: key);

  final void Function() onGallerySelect;
  final void Function() onCameraSelect;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        'Choose source of the image',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      children: [
        SourceSelectionOption(
          onTap: onGallerySelect,
          text: 'Gallery',
        ),
        const Divider(
          height: 15,
          thickness: 2,
        ),
        SourceSelectionOption(
          onTap: onCameraSelect,
          text: 'Camera',
        ),
      ],
    );
  }
}
