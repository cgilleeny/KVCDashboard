import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/data/eyepair_image/eyepair_image_repository.dart';

import '../data/model/eyepair.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageRepository repository;

  ImageCubit(this.repository) : super(ImageInitial());

  void fetchPortrait(String rowKey) {
    emit(ImageLoading());
    repository.fetchImage(rowKey, '_full.jpg', cropBottom: true).then((memoryImage) {
      emit(ImageLoaded(memoryImage));
    }).catchError((error) {
      emit(ImageLoadingError(error.toString()));
    });
  }

  void fetchLeftEye(String rowKey) {
    emit(ImageLoading());
    repository.fetchImage(rowKey, '_left_detection.png').then((memoryImage) {
      emit(ImageLoaded(memoryImage));
    }).catchError((error) {
      emit(ImageLoadingError(error.toString()));
    });
  }

  void fetchRightEye(String rowKey) {
    emit(ImageLoading(),);
    repository.fetchImage(rowKey, '_right_detection.png').then((memoryImage) {
      emit(ImageLoaded(memoryImage,),);
    }).catchError((error) {
      emit(ImageLoadingError(error.toString(),),);
    });
  }

  void fetchEyepairImage(EyePair eyepair) {
    emit(ImagesLoading());

    if (eyepair.rowKey != 'Unknown RowKey') {
      if (eyepair.right != null && eyepair.left != null) {
        repository
            .fetchImage(eyepair.rowKey, '_right_detection.png')
            .then((memoryImage) {
          eyepair.right?.detectionImage = memoryImage;

          // eyepair.right!.detectionImageBytes = imageBytes;

          repository
              .fetchImage(eyepair.rowKey, '_left_detection.png')
              .then((memoryImage) {
            eyepair.left?.detectionImage = memoryImage;
            emit(ImagesLoaded());
          }).catchError((error) {
            emit(ImagesLoadingError(error.toString()));
          });
        }).catchError((error) {
          emit(ImagesLoadingError(error.toString()));
        });
      }
    }
  }

  void fetchEyepairImages(List<EyePair> eyepairs) async {
    for (var eyepair in eyepairs) {
      emit(ImagesLoading());
      if (eyepair.rowKey != 'Unknown RowKey') {
        if (eyepair.right != null && eyepair.left != null) {
          try {
            eyepair.right?.detectionImage = await repository.fetchImage(
                eyepair.rowKey, '_right_detection.png');
          } catch (error) {
            emit(ImagesLoadingError(error.toString()));
          }

          try {
            eyepair.left?.detectionImage = await repository.fetchImage(
                eyepair.rowKey, '_left_detection.png');
          } catch (error) {
            emit(ImagesLoadingError(error.toString()));
          }
          emit(ImagesLoaded());
        }
      }
    }
    
  }
}
