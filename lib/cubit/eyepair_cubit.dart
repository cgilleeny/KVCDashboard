import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_check_kidz_dashboard/data/eyepair/eyepair_repository.dart';

import '../data/model/classification.dart';
import '../data/model/eyepair.dart';
import '../data/model/filter.dart';
import '../data/model/page.dart';

part 'eyepair_state.dart';

class EyepairCubit extends Cubit<EyepairState> {
  final EyepairRepository repository;
  EyepairCubit(this.repository) : super(EyepairInitial());

  void fetchFirstPage({Filter? filter}) {
    emit(EyepairsLoading());
    repository.fetchEyepairsFirst(filter).then((eyepairs) {
      emit(EyepairsLoaded(eyepairs));
    }).catchError((error) {
      emit(EyepairsError(error.toString()));
    });
  }

  void fetchPage(int page) {
    emit(EyepairsLoading());
    repository.fetchEyepairs(page).then((eyepairPage) {
      emit(EyepairsLoaded(eyepairPage));
    }).catchError((error) {
      emit(EyepairsError(error.toString()));
    });
  }

  void updateEyepair(String rowKey, Map<String, dynamic> map) {
    emit(EyepairUpdating());
    repository.updateEyepair(rowKey, map).then((classification) {
      emit(EyepairUpdated(classification));
    }).catchError((error) {
      emit(EyepairUpdateError(error.toString()));
    });
  }

  void fetchFilter() {
    emit(
      EyepairsFilter(
        repository.fetchFilter(),
      ),
    );
  }
}
