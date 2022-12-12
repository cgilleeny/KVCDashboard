part of 'dashboard_users_cubit.dart';

abstract class DashboardUsersState extends Equatable {
  const DashboardUsersState();

  @override
  List<Object> get props => [];
}

class DashboardUsersInitial extends DashboardUsersState {}

class DashboardUsersLoading extends DashboardUsersState {}

class DashboardUsersLoaded extends DashboardUsersState {
  final List<DashboardUser> dashboardUsers;

  const DashboardUsersLoaded(this.dashboardUsers);
}

class DashboardUsersLoadError extends DashboardUsersState {
  final String errorDescription;

  const DashboardUsersLoadError(this.errorDescription);
}

class DashboardUserUpdating extends DashboardUsersState {}

class DashboardUserUpdated extends DashboardUsersState {}

class DashboardUserUpdateError extends DashboardUsersState {
  final String errorDescription;

  const DashboardUserUpdateError(this.errorDescription);
}

class DashboardUserInserting extends DashboardUsersState {}

class DashboardUserInserted extends DashboardUsersState {}

class DashboardUserInsertError extends DashboardUsersState {
  final String errorDescription;

  const DashboardUserInsertError(this.errorDescription);
}

class DashboardUserFound extends DashboardUsersState {
  final DashboardUser dashboardUser;
  
  const DashboardUserFound(this.dashboardUser);
}

class DashboardUserNotFound extends DashboardUsersState {}
