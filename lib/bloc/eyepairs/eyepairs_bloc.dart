/*
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/eyepair.dart';
import '../../data/model/filter.dart';
import '../../data/model/page.dart';
import '../../azure.dart';
import '../../data/eyepair/eyepair_network_service.dart';

part 'eyepairs_event.dart';
part 'eyepairs_state.dart';

class EyepairsBloc extends Bloc<EyepairsEvent, EyepairsState> {
  EyepairsBloc() : super(EyepairsInitial()) {
    on<LoadEyepairs>(_onLoadEyepairs);
    on<LoadEyepair>(_onLoadEyepair);
    on<LoadEyepairImages>(_onLoadEyepairImages);
    on<UpdateEyepair>(_onUpdateEyepair);
  }

  Future<void> _onLoadEyepairImages(
      LoadEyepairImages event, Emitter<EyepairsState> emit) async {
    for (var eyepair in event.page.eyepairs) {
      try {
        if (eyepair.left != null && eyepair.right != null) {
          emit(
            EyepairImageLoading(),
          );
          final networkService = EyepairNetworkService();
          final leftImageBytes =
              await networkService.fetchEyeImage(eyepair, '_left_symmetry.png');
          final rightImageBytes = await networkService.fetchEyeImage(
              eyepair, '_right_symmetry.png');
          eyepair.left?.detectionImageBytes = leftImageBytes;
          eyepair.right?.detectionImageBytes = rightImageBytes;
          if (leftImageBytes != null || rightImageBytes != null) {
            emit(
              EyepairImageLoaded(page: event.page),
            );
          }
        }
      } on Exception catch (e) {
        emit(
          EyepairsError('Screening ID: ${eyepair.rowKey} - ${e.toString()}'),
        );
        break;
      }
    }
  }

  Future<void> _onLoadEyepairs(
      LoadEyepairs event, Emitter<EyepairsState> emit) async {
    emit(
      EyepairsLoading(),
    );
    try {
      final networkService = EyepairNetworkService();
      final page = await networkService.fetchEyepairs(
          event.filter, event.page, event.rowsPerPage);
      emit(
        EyepairsLoaded(page: page),
      );
    } on Exception catch (e) {
      emit(
        EyepairsError(e.toString()),
      );
    }
  }

  Future<void> _onLoadEyepair(
      LoadEyepair event, Emitter<EyepairsState> emit) async {
    emit(
      EyepairsLoading(),
    );
    try {
      final networkService = EyepairNetworkService();
      final eyepair = await networkService.fetchEyepair(event.rowKey);
      if (eyepair != null) {
        emit(
          EyepairLoaded(eyepair,),
        );
      } else {
        emit(
          EyepairsError('Record with RowKey: ${event.rowKey} not found'),
        );
      }
    } on Exception catch (e) {
      emit(
        EyepairsError(e.toString()),
      );
    }
  }

  Future<void> _onUpdateEyepair(
      UpdateEyepair event, Emitter<EyepairsState> emit) async {
    emit(
      EyepairsLoading(),
    );
    try {
      final networkService = EyepairNetworkService();
      const JsonEncoder encoder = JsonEncoder();
      final body = encoder.convert(event.map);
      await networkService.updateEyepair(event.rowKey, body);
      final eyepair = await networkService.fetchEyepair(event.rowKey);
      if (eyepair != null) {
        emit(
          EyepairLoaded(eyepair,),
        );
      } else {
        emit(
          EyepairsError('Record with RowKey: ${event.rowKey} not found'),
        );
      }
    } on Exception catch (e) {
      emit(
        EyepairsError(e.toString()),
      );
    }
  }
}
*/