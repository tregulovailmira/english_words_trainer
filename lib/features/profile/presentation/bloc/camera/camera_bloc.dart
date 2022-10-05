import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState()) {
    on<StartCamera>((event, emit) async {
      emit(await _startCamera());
    });
    on<ChangeCameraDirection>((event, emit) {
      final direction = state.direction == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      emit(
        CameraState(
          isInitialized: state.isInitialized,
          direction: direction,
          cameraController: state.cameraController,
          cameras: state.cameras,
          isError: state.isError,
          errorMessage: state.errorMessage,
          photo: state.photo,
        ),
      );
      add(StartCamera());
    });
    on<MakePhoto>((event, emit) async {
      final xFile = await _makePhoto();
      emit(
        CameraState(
          isInitialized: state.isInitialized,
          direction: state.direction,
          cameraController: state.cameraController,
          cameras: state.cameras,
          isError: state.isError,
          errorMessage: state.errorMessage,
          isPhotoMade: true,
          photo: xFile,
        ),
      );
    });
    on<CancelMadePhoto>((event, emit) {
      emit(
        CameraState(
          isInitialized: state.isInitialized,
          direction: state.direction,
          cameraController: state.cameraController,
          cameras: state.cameras,
          isError: state.isError,
          errorMessage: state.errorMessage,
        ),
      );
    });
    on<ClearCameraController>((event, emit) {
      state.cameraController!.dispose();
      emit(const CameraState());
    });
  }

  Future<CameraState> _startCamera() async {
    try {
      final cameras = await availableCameras();
      final cameraIndex = cameras.indexWhere(
        (camera) => camera.lensDirection == state.direction,
      );

      final controller = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();

      return CameraState(
        isInitialized: true,
        cameraController: controller,
        cameras: cameras,
        direction: state.direction,
      );
    } catch (e) {
      final message = _cameraExceptionHandler(e);
      return CameraState(isError: true, errorMessage: message);
    }
  }

  String _cameraExceptionHandler(exception) {
    if (exception is CameraException) {
      switch (exception.code) {
        case 'CameraAccessDenied':
          return 'User denied camera access';
        default:
          return 'Unexpected Camera Error with code \'${exception.code}\'';
      }
    } else {
      return exception.toString();
    }
  }

  Future<XFile> _makePhoto() async {
    final xfile = await state.cameraController!.takePicture();

    return state.direction == CameraLensDirection.front
        ? await _processSelfie(xfile)
        : xfile;
  }

  Future<XFile> _processSelfie(XFile xfile) async {
    final imageBytes = await xfile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    final fixedImage = img.flipHorizontal(originalImage!);
    final file = File(xfile.path);
    final fixedFile = await file.writeAsBytes(
      img.encodeJpg(fixedImage),
      flush: true,
    );
    return XFile(fixedFile.path);
  }
}
