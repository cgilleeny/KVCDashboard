/*
part of 'eyepairs_bloc.dart';

abstract class EyepairsEvent extends Equatable {
  const EyepairsEvent();

  @override
  List<Object> get props => [];
}

class RefreshEyepairs extends EyepairsEvent {
  const RefreshEyepairs();

  @override
  List<Object> get props => [];
}

class UpdateEyepair extends EyepairsEvent {
  final String rowKey;
  final Map<String, dynamic> map;

  const UpdateEyepair(
    this.rowKey,
    this.map,
  );

  @override
  List<Object> get props => [rowKey, map];
}

class LoadEyepair extends EyepairsEvent {
  final String rowKey;
  final int pageIndex;

  const LoadEyepair(
    this.rowKey,
    this.pageIndex,
  );

  @override
  List<Object> get props => [rowKey];
}

class LoadEyepairs extends EyepairsEvent {
  final EyepairPage page;
  final Filter? filter;
  final int rowsPerPage;

  const LoadEyepairs(
    this.filter, {
    this.page = const EyepairPage(<EyePair>[], 10),
    this.rowsPerPage = 10,
  });

  @override
  List<Object> get props => [page, rowsPerPage];
}

class LoadEyepairImages extends EyepairsEvent {
  final EyepairPage page;

  const LoadEyepairImages({
    this.page = const EyepairPage(<EyePair>[]),
  });

  @override
  List<Object> get props => [page];
}
*/