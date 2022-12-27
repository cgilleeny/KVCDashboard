// import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:go_check_kidz_dashboard/azure.dart';
// import 'package:http/http.dart' as http;
import 'package:azstore/azstore.dart';
// import '../../azure.dart';
// import '../../azure.dart';
import '../../keys/azure_connection_strings.dart';
import '../model/dashboard_user.dart';

// const String dashboardUserURL =
//     'https://visionscreenerdata.table.core.windows.net/dashboardusers';

class DashboardUserNetworkService {
  final AzureStorage storage;
  final String tableName;
  DashboardUserNetworkService(this.storage, this.tableName);

  Future<void> upsertDashboardUser(DashboardUser dashboardUser) async {
    // var storage = AzureStorage.parse(dashboardUserConnectionString);
    return storage
        .upsertTableRow(
            tableName: tableName,
            rowKey: dashboardUser.email,
            partitionKey: 'main',
            bodyMap: dashboardUser.toMap())
        .catchError((error) {
      throw Exception(error.toString());
    });
    /*
    final url = Uri.parse(dashboardUserURL);
    return client
        .post(url,
            headers:
                getHeaders('dashboardusers', dashboardUserConnectionString),
            body: dashboardUser.toJson())
        .then((response) {
      if (response.statusCode != 201) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });
    */
  }
/*
  Future<void> updateDashboardUser(DashboardUser dashboardUser) async {
    // var storage = AzureStorage.parse(dashboardUserConnectionString);
    return storage
        .upsertTableRow(
            tableName: tableName,
            rowKey: dashboardUser.email,
            partitionKey: 'main',
            bodyMap: dashboardUser.toMap())
        .catchError((error) {
      throw Exception(error.toString());
    });
  }
*/
/*
  Future<void> updateDashboardUser(http.Client client, DashboardUser dashboardUser) async {
    final url = Uri.parse(
        '$dashboardUserURL(PartitionKey=\'main\',RowKey=\'${dashboardUser.email}\')');
    return client
        .put(url,
            headers: getHeaders('dashboardusers', dashboardUserConnectionString,
                whereClause:
                    '(PartitionKey=\'main\',RowKey=\'${dashboardUser.email}\')'),
            body: dashboardUser.toJson())
        .then((response) {
      if (response.statusCode != 204) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
*/

  Future<List<DashboardUser>> fetchDashboardUsers() {
    // var storage = AzureStorage.parse(dashboardUserConnectionString);
    return storage
        .filterNextTableRows(
            tableName: tableName,
            // filter: '',
            top: 100)
        .then((map) {
      final rows = map["Rows"];
      if (rows == null) {
        return throw Exception('Expected non-null rows from dadhboard users');
      }
      final List<DashboardUser> dashboardUsers = [];
      for (var row in rows) {
        try {
          // final dashboardUser = DashboardUser.fromJson(row);
          dashboardUsers.add(DashboardUser.fromJson(row));
        } catch (error) {
          if (kDebugMode) {
            print(error.toString());
          }
        }
      }
      if (kDebugMode) {
        print("Number of users: ${dashboardUsers.length}");
      }
      return dashboardUsers;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
/*

  Future<List<DashboardUser>> fetchDashboardUsers(http.Client client) {  
    final url = Uri.parse('$dashboardUserURL?\$top=100');
    return client
        .get(
      url,
      headers: getHeaders('dashboardusers', dashboardUserConnectionString),
    )
        .then((response) {
      if (response.statusCode > 299) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
      return json.decode(response.body);
    }).then((json) {
      final list = json['value'];
      if (list is! List<dynamic>) {
        expectedField('value');
      }
      final List<DashboardUser> dashboardUsers = [];
      for (var jsonDashboardUser in list) {
        try {
          final dashboardUser = DashboardUser.fromJson(jsonDashboardUser);
          dashboardUsers.add(dashboardUser);
        } catch (error) {
          if (kDebugMode) {
            print(error.toString());
          }
        }
      }
      if (kDebugMode) {
        print("Number of users: ${dashboardUsers.length}");
      }
      return dashboardUsers;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
*/
}
