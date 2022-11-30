/*
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../azure.dart';
import '../../data/model/eyepair.dart';
import '../../data/eyepair/eyepair_network_service.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  static const String connectionString =
      'DefaultEndpointsProtocol=https;AccountName=uploadphotodata;AccountKey=4QqBQw3x0AAjGJDGHOD+KZsnbaxAy/jHexFWuegJMNGwjjtnrdH60Q/g319PJ8qmn3rNnBDuWV0O+AStasfWDw==;EndpointSuffix=core.windows.net';

  static const String baseURL = 'https://uploadphotodata.blob.core.windows.net';

  ImageBloc() : super(ImageInitial()) {
    on<LoadFullImage>(_onLoadFullEyeImage);
    on<LoadDetectionImages>(_onLoadDetectionImages);
    // on<LoadLeftImage>(_onLoadLeftEyeImage);
    // on<LoadRightImage>(_onLoadRightEyeImage);
  }

  Future<void> _onLoadDetectionImages(
      LoadDetectionImages event, Emitter<ImageState> emit) async {
    for (var eyepair in event.eyepairs) {
      emit(
        ImageLoading(),
      );
      try {
        if (eyepair.left != null && eyepair.right != null) {
          emit(
            ImageLoading(),
          );
          final networkService = EyepairNetworkService();
          final leftImageBytes =
              await networkService.fetchEyeImage(eyepair, '_left_symmetry.png');
          final rightImageBytes = await networkService.fetchEyeImage(
              eyepair, '_right_symmetry.png');
          // if (leftImageBytes == null || rightImageBytes == null) {
          //   emit(
          //     ImageError(
          //         'Screening ID: ${eyepair.rowKey} - Left/Right detection image file not found'),
          //   );
          // }
          eyepair.left?.detectionImageBytes = leftImageBytes;
          eyepair.right?.detectionImageBytes = rightImageBytes;
          if (leftImageBytes != null || rightImageBytes != null) {
            emit(
              const ImageLoaded(),
            );
          }
        }

        // emit(
        //   LeftImageLoaded(imageBytes),
        // );
      } on Exception catch (e) {
        emit(
          ImageError('Screening ID: ${eyepair.rowKey} - ${e.toString()}'),
        );
        break;
      }
    }
  }

  Future<void> _onLoadFullEyeImage(
      LoadFullImage event, Emitter<ImageState> emit) async {
    emit(
      ImageLoading(),
    );
    try {
      final networkService = EyepairNetworkService();
      final imageBytes =
          await networkService.fetchEyeImage(event.eyepair, '_full.png');
      if (imageBytes == null) {
        emit(
          FullImageError(
              'Screening ID: ${event.eyepair.rowKey} - Full image file not found'),
        );
      } else {
        emit(
          FullImageLoaded(imageBytes),
        );
      }
    } on Exception catch (e) {
      emit(
        FullImageError(
            'Screening ID: ${event.eyepair.rowKey} - ${e.toString()}'),
      );
    }
  }

/*
  Future<Uint8List?> _fetchEyeImage(
    EyePair eyepair,
    String suffix,
  ) {
    if (eyepair.rowKey == null) {
      throw Exception('Could not load image for unknown rowKey');
    }

    final azure = Azure(connectionString);

    // var suffix = '_full.jpg';

    final path = "/data/${eyepair.rowKey!}/${eyepair.rowKey!}$suffix";

    if (kDebugMode) {
      print(path);
    }
    // final fullPath = "$baseURL$path";
    // print("fullPath: $fullPath");
    final url = Uri.parse("$baseURL$path");
    Map<String, String> headers = azure.getBlobHeader(path);

    return http
        .get(
      url,
      headers: headers,
    )
        .then((response) async {
      // print("full statusCode: ${response.statusCode}");
      if (response.statusCode > 299) {
        if (response.statusCode == 404) {
          // not found
          return null;
        }
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
      // if (response.statusCode > 299) {
      //   _loading = false;
      //   if (response.statusCode == 404) {
      //     _error = 'No image found';
      //     notifyListeners();
      //     return;
      //   }
      //   notifyListeners();
      //   throw Exception(response.toString());
      // }

      return response.bodyBytes;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
*/
}
*/