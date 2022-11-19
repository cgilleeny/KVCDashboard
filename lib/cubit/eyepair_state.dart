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
