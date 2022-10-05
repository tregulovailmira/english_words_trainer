part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class StartCamera extends CameraEvent {}

class ChangeCameraDirection extends CameraEvent {}

class MakePhoto extends CameraEvent {}

class CancelMadePhoto extends CameraEvent {}

class ClearCameraController extends CameraEvent {}
