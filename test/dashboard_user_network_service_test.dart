
import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/dashboard_user.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_network_service.dart';
import 'package:go_check_kidz_dashboard/keys/azure_connection_strings.dart';
import 'package:azstore/azstore.dart';

void main() {
  group('dashboard user API call', () {
    final storage = AzureStorage.parse(dashboardUserConnectionString);
    storage.deleteTableRow(
        partitionKey: 'main',
        rowKey: 'testemail@gmail.com',
        tableName: 'testdashboardusers');

    test('Should insert a dashboard user', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');
      const dashboarduser = DashboardUser(
          email: 'testemail@gmail.com', read: true, write: true, admin: false);
      // ACT && ASSERT
      await networkService.upsertDashboardUser(dashboarduser);
    });

    test('Should return list of dashboard users', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');

      final dashboardusers = await networkService.fetchDashboardUsers();

      // ACT && ASSERT
      expect(dashboardusers, isA<List<DashboardUser>>());
      expect(dashboardusers[0].email, 'testemail@gmail.com');
    });

    test('Should update a dashboard user', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');
      const dashboarduser = DashboardUser(
          email: 'testemail@gmail.com', read: true, write: true, admin: true);
      // ACT && ASSERT
      await networkService.upsertDashboardUser(dashboarduser);
    });

    test('Should return modified user in list of dashboard users', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');

      final dashboardusers = await networkService.fetchDashboardUsers();

      // ACT && ASSERT
      expect(dashboardusers[0].admin, true);
    });
  });
}
