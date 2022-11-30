/*
part of 'eyepairs_bloc.dart';

abstract class EyepairsState extends Equatable {
  const EyepairsState();

  @override
  List<Object> get props => [];
}

class EyepairsInitial extends EyepairsState {}

class EyepairsLoading extends EyepairsState {}

class EyepairImageLoading extends EyepairsState {}

class EyepairLoaded extends EyepairsState {
  final EyePair eyepair;

  const EyepairLoaded(this.eyepair,);

  @override
  List<Object> get props => [eyepair];
}

class EyepairsLoaded extends EyepairsState {
  final EyepairPage page;

  const EyepairsLoaded({this.page = const EyepairPage(<EyePair>[])});

  @override
  List<Object> get props => [page];
}

class EyepairImageLoaded extends EyepairsState {
  final EyepairPage page;

  const EyepairImageLoaded({this.page = const EyepairPage(<EyePair>[])});

  @override
  List<Object> get props => [page];
}

class EyepairsError extends EyepairsState {
  final String errorDescription;

  const EyepairsError(this.errorDescription);

  @override
  List<Object> get props => [errorDescription];
}
*/