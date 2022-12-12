import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../azure.dart';
import '../../keys/azure_connection_strings.dart';
import '../model/dashboard_user.dart';

class DashboardUserNetworkService with Azure {

  DashboardUserNetworkService();

  Future<void> insertDashboardUser(DashboardUser dashboardUser) async {
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(dashboardUserConnectionString);
    final url = Uri.parse(baseURL);
    return http
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
  }

  Future<void> updateDashboardUser(DashboardUser dashboardUser) async {
    // const String dashboardUserConnectionString =
    //     'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(dashboardUserConnectionString);
    final url = Uri.parse(
        '$baseURL(PartitionKey=\'main\',RowKey=\'${dashboardUser.email}\')');
    return http
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

  Future<List<DashboardUser>> fetchDashboardUsers() {
    // const String dashboardUserConnectionString =
    //     'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(dashboardUserConnectionString);
    final url = Uri.parse('$baseURL?\$top=100');
    return http
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
      for (var dashboardUser in list) {
        dashboardUsers.add(DashboardUser.fromJson(dashboardUser));
      }
      if (kDebugMode) {
        print("Number of users: ${dashboardUsers.length}");
      }
      return dashboardUsers;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
}
