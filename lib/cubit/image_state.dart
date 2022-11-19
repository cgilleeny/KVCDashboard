part of 'image_cubit.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImagesLoading extends ImageState {}

class ImagesLoaded extends ImageState {}



class ImagesLoadingError extends ImageState {
  final String errorDescription;

  const ImagesLoadingError(this.errorDescription);
}

class ImageLoading extends ImageState {}


class ImageLoaded extends ImageState {
  final MemoryImage? memoryImage;

  const ImageLoaded(this.memoryImage);
}

class ImageLoadingError extends ImageState {
  final String errorDescription;

  const ImageLoadingError(this.errorDescription);
}