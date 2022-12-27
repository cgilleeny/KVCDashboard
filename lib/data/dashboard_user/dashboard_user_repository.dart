import 'package:collection/collection.dart';
import 'package:go_check_kidz_dashboard/data/model/dashboard_user.dart';
// import 'package:http/http.dart' as http;
import 'dashboard_user_network_service.dart';

class DashboardUserRepository {
  final DashboardUserNetworkService networkService;
  List<DashboardUser> dashboardUsers = [];
  DashboardUser? dashboardUser;

  DashboardUserRepository(this.networkService);

  Future<List<DashboardUser>> fetchDashboardUsers() async {
    dashboardUsers = await networkService.fetchDashboardUsers();
    return dashboardUsers;
  }

  DashboardUser? fetchDashboardUser(String socialEmail) {
    dashboardUser = dashboardUsers.firstWhereOrNull((dashboardUser) =>
        dashboardUser.email.toLowerCase() == socialEmail.toLowerCase());
    return dashboardUser;
  }

  Future<void> insertDashboardUser(DashboardUser dashboardUser) async {
    await networkService.upsertDashboardUser(dashboardUser);
  }

  Future<void> updateDashboardUser(DashboardUser dashboardUser) async {
    await networkService.upsertDashboardUser(dashboardUser);
  }
}
