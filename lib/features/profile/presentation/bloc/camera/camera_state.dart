part of 'camera_bloc.dart';

class CameraState extends Equatable {
  final bool isInitialized;
  final CameraLensDirection direction;
  final CameraController? cameraController;
  final List<CameraDescription>? cameras;
  final bool isError;
  final String? errorMessage;
  final bool isPhotoMade;
  final XFile? photo;

  const CameraState({
    this.isInitialized = false,
    this.direction = CameraLensDirection.front,
    this.cameraController,
    this.cameras,
    this.isError = false,
    this.errorMessage,
    this.isPhotoMade = false,
    this.photo,
  });

  @override
  List<Object?> get props => [
        isInitialized,
        direction,
        cameraController,
        cameras,
        isError,
        errorMessage,
        isPhotoMade,
        photo,
      ];
}
