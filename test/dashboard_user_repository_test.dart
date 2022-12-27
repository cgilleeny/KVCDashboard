import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/dashboard_user.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_network_service.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_repository.dart';
import 'package:go_check_kidz_dashboard/keys/azure_connection_strings.dart';
import 'package:azstore/azstore.dart';

void main() {
  group('dashboard repository', () {
    final storage = AzureStorage.parse(dashboardUserConnectionString);
    
    final repository = DashboardUserRepository(
        DashboardUserNetworkService(storage, 'testdashboardusers'));

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

      // ACT && ASSERT
      final dashboardusers = await repository.fetchDashboardUsers();
      expect(dashboardusers, isA<List<DashboardUser>>());
      expect(dashboardusers.length, 3);
    });

    test('Should return selected dashboard user', () async {
      // ARRANGE

      // ACT && ASSERT
      final dashboarduser = repository.fetchDashboardUser('user_1@gmail.com');
      expect(dashboarduser, isA<DashboardUser>());
      expect(dashboarduser?.email, 'user_1@gmail.com');
    });

    test('Should insert a dashboard user', () async {
      // ARRANGE
      const dashboarduser = DashboardUser(
          email: 'user_4@gmail.com', read: true, write: true, admin: false);

      // ACT && ASSERT
      await repository.insertDashboardUser(dashboarduser);
      await repository.fetchDashboardUsers();
      final fetchedDashboarduser = repository.fetchDashboardUser('user_4@gmail.com');
      await storage.deleteTableRow(
          tableName: 'testdashboardusers',
          partitionKey: 'main',
          rowKey: 'user_4@gmail.com');
      expect(fetchedDashboarduser, isA<DashboardUser>());
      expect(fetchedDashboarduser?.email, 'user_4@gmail.com');
    });

    test('Should update a dashboard user', () async {
      // ARRANGE
      const dashboarduser = DashboardUser(
          email: 'user_1@gmail.com', read: true, write: true, admin: false);

      // ACT && ASSERT
      await repository.insertDashboardUser(dashboarduser);
      await repository.fetchDashboardUsers();
      final fetchedDashboarduser = repository.fetchDashboardUser('user_1@gmail.com');
      expect(fetchedDashboarduser, isA<DashboardUser>());
      expect(fetchedDashboarduser?.admin, false);
    });
  });
}
