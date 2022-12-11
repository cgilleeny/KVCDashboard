import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/dashboard_user/dashboard_user_repository.dart';
import '../data/model/dashboard_user.dart';

part 'dashboard_users_state.dart';

class DashboardUsersCubit extends Cubit<DashboardUsersState> {
  final DashboardUserRepository repository;
  DashboardUsersCubit(this.repository) : super(DashboardUsersInitial());

  void fetchDashboardUsers() {
    emit(
      DashboardUsersLoading(),
    );
    repository.fetchDashboardUsers().then((dashboardUsers) {
      emit(
        DashboardUsersLoaded(dashboardUsers),
      );
    }).catchError((error) {
      emit(
        DashboardUsersLoadError(
          error.toString(),
        ),
      );
    });
  }

  void fetchDashboardUser(String socialEmail) {
    final dashboardUser = repository.fetchDashboardUser(socialEmail);
    if (dashboardUser != null) {
      return emit(
        DashboardUserFound(dashboardUser),
      );
    }
    emit(DashboardUserNotFound());
  }

  void updateDashboardUser(DashboardUser? dashboardUser) {
    if (dashboardUser == null) {
      return emit(
        const DashboardUserUpdateError(
          'No changes to update.',
        ),
      );
    }
    emit(
      DashboardUserUpdating(),
    );
    repository.updateDashboardUser(dashboardUser).then((_) {
      emit(DashboardUserUpdated());
    }).catchError((error) {
      emit(
        DashboardUserUpdateError(
          error.toString(),
        ),
      );
    });
  }

  void insertDashboardUser(DashboardUser dashboardUser) {
    if (dashboardUser.email.isEmpty) {
      return emit(
        const DashboardUserInsertError(
          'Social email required to add dashboard user.',
        ),
      );
    }
    if (!dashboardUser.read) {
      return emit(
        const DashboardUserInsertError(
          'Read permission required for active dashboard users.',
        ),
      );
    }
    emit(
      DashboardUserInserting(),
    );
    repository.insertDashboardUser(dashboardUser).then((_) {
      emit(DashboardUserInserted());
    }).catchError((error) {
      emit(
        DashboardUserInsertError(
          error.toString(),
        ),
      );
    });
  }

  void reset() {
    emit(DashboardUsersInitial());
  }
}
