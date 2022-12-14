import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/dashboard_user.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_network_service.dart';
import 'package:go_check_kidz_dashboard/keys/azure_connection_strings.dart';
import 'package:azstore/azstore.dart';

void main() {
  group('dashboard user API call', () {
    final storage = AzureStorage.parse(dashboardUserConnectionString);
    test('Should return list of dashboard users', () async {
      // ARRANGE
      for (var i = 1; i < 4; i++) {
        final dashboarduser = DashboardUser(
            email: 'user_$i@gmail.com', read: true, write: true, admin: true);
        await storage.upsertTableRow(
            tableName: 'testdashboardusers',
            partitionKey: 'main',
            rowKey: 'user_$i@gmail.com',
            body: dashboarduser.toJson());
      }
      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');

      final dashboardusers = await networkService.fetchDashboardUsers();

      // ACT && ASSERT
      expect(dashboardusers, isA<List<DashboardUser>>());
      expect(dashboardusers.length, 3);
      expect(dashboardusers[0].email, 'user_1@gmail.com');
    });

    test('Should insert a dashboard user', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');
      const dashboarduser = DashboardUser(
          email: 'user_4@gmail.com', read: true, write: true, admin: false);
      // ACT && ASSERT
      await networkService.upsertDashboardUser(dashboarduser);
      final dashboardusers = await networkService.fetchDashboardUsers();
      await storage.deleteTableRow(
          tableName: 'testdashboardusers',
          partitionKey: 'main',
          rowKey: 'user_4@gmail.com');
      expect(dashboardusers, isA<List<DashboardUser>>());
      expect(dashboardusers.length, 4);
      expect(dashboardusers[3].email, 'user_4@gmail.com');

    });

    test('Should update a dashboard user', () async {
      // ARRANGE

      final networkService =
          DashboardUserNetworkService(storage, 'testdashboardusers');
      const dashboarduser = DashboardUser(
          email: 'user_1@gmail.com', read: true, write: true, admin: false);
      // ACT && ASSERT
      await networkService.upsertDashboardUser(dashboarduser);
      final dashboardusers = await networkService.fetchDashboardUsers();
      expect(dashboardusers, isA<List<DashboardUser>>());
      expect(dashboardusers.length, 3);
      expect(dashboardusers[0].admin, false);
    });
  });
}
