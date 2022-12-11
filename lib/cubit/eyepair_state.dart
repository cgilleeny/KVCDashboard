part of 'eyepair_cubit.dart';

abstract class EyepairState extends Equatable {
  const EyepairState();

  @override
  List<Object> get props => [];
}

class EyepairInitial extends EyepairState {}

class EyepairsLoading extends EyepairState {}

class EyepairsLoaded extends EyepairState {
  final EyepairPage page;

  const EyepairsLoaded(this.page);
}

class EyepairsError extends EyepairState {
  final String errorDescription;

  const EyepairsError(this.errorDescription);
}

class EyepairsFilter extends EyepairState {
  final Filter? filter;

  const EyepairsFilter(this.filter);
}

class EyepairUpdating extends EyepairState {}

class EyepairUpdated extends EyepairState {
  final String classification;

  const EyepairUpdated(this.classification);
}

class EyepairUpdateError extends EyepairState {
  final String errorDescription;

  const EyepairUpdateError(this.errorDescription);
}
