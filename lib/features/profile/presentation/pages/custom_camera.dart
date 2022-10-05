import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../routes.dart';
import '../bloc/camera/camera_bloc.dart';
import '../widgets/camera.dart';
import '../widgets/photo_preview.dart';

class CustomCamera extends StatefulWidget {
  const CustomCamera({required this.onUploadPhoto, Key? key}) : super(key: key);

  final Function onUploadPhoto;
  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera> {
  @override
  void initState() {
    super.initState();
    startCamera();
  }

  void startCamera() {
    context.read<CameraBloc>().add(StartCamera());
  }

  void changeCameraDirection() {
    context.read<CameraBloc>().add(ChangeCameraDirection());
  }

  void makePhoto() {
    context.read<CameraBloc>().add(MakePhoto());
  }

  void cancelMadePhoto() {
    context.read<CameraBloc>().add(CancelMadePhoto());
  }

  void Function() uploadPhoto(BuildContext context, XFile photo) => () {
        widget.onUploadPhoto(photo);
        Navigator.of(context).popUntil(ModalRoute.withName(Routes.profile));
      };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraBloc, CameraState>(
      listener: (BuildContext context, state) {
        if (state.isError) {
          context.showErrorSnackBar(message: state.errorMessage!);
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.profile));
        }
      },
      builder: (BuildContext context, state) {
        if (state.isPhotoMade) {
          return PhotoPreview(
            photo: File(state.photo!.path),
            cancelMadePhoto: cancelMadePhoto,
            uploadPhoto: uploadPhoto(context, state.photo!),
          );
        }
        if (state.isInitialized) {
          return Camera(
            changeCameraDirection: changeCameraDirection,
            onCreatePhoto: makePhoto,
            cameraController: state.cameraController!,
          );
        }
        return Container();
      },
    );
  }
}
