import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/data/eyepair_image/eyepair_image_repository.dart';

import '../data/model/eyepair.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageRepository repository;

  ImageCubit(this.repository) : super(ImageInitial());

  void fetchImage(String rowKey, String suffix) {
    emit(ImageLoading());
    repository.fetchImage(rowKey, suffix, cropBottom: true).then((memoryImage) {
      emit(ImageLoaded(memoryImage));
    }).catchError((error) {
      emit(ImageLoadingError(error.toString()));
    });
  }

  void fetchEyeImages(EyePair eyepair) {
    emit(ImagesLoading());

    if (eyepair.rowKey != null) {
      if (eyepair.right != null && eyepair.left != null) {
        repository
            .fetchImage(eyepair.rowKey!, '_right_detection.png')
            .then((memoryImage) {

            eyepair.right?.detectionImage = memoryImage;
            
          // eyepair.right!.detectionImageBytes = imageBytes;

          repository
              .fetchImage(eyepair.rowKey!, '_left_detection.png')
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
}