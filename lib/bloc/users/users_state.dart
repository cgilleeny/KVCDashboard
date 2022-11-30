/*
part of '../users/users_bloc.dart';

abstract class AzureUsersState extends Equatable {
  const AzureUsersState();

  @override
  List<Object> get props => [];
}

class AzureUsersInitial extends AzureUsersState {}

class AzureUsersLoading extends AzureUsersState {}

class AzureUsersLoaded extends AzureUsersState {
  final List<AzureUser> azureUsers;

  const AzureUsersLoaded({this.azureUsers = const <AzureUser>[]});

  @override
  List<Object> get props => [azureUsers];
}

class AzureUsersLoadError extends AzureUsersState {
  final String errorDescription;

  const AzureUsersLoadError(this.errorDescription);

  @override
  List<Object> get props => [errorDescription];
}

class AzureUserUpdating extends AzureUsersState {}

class AzureUserUpdated extends AzureUsersState {}

class AzureUserUpdateError extends AzureUsersState {
  final String errorDescription;

  const AzureUserUpdateError(this.errorDescription);

  @override
  List<Object> get props => [errorDescription];
}

class AzureUserInserting extends AzureUsersState {}

class AzureUserInserted extends AzureUsersState {}

class AzureUserInsertError extends AzureUsersState {
  final String errorDescription;

  const AzureUserInsertError(this.errorDescription);

  @override
  List<Object> get props => [errorDescription];
}
*/