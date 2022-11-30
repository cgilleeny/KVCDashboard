import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../azure.dart';
import '../model/azure_user.dart';

class AzureuserNetworkService with Azure {
  static const connectionString =
      'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
  
  AzureuserNetworkService();

  Future<void> insertAzureUser(AzureUser azureUser) async {
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(connectionString);
    final url = Uri.parse(baseURL);
    return http
        .post(url,
            headers: getHeaders('dashboardusers', connectionString),
            body: azureUser.toJson())
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

  Future<void> updateAzureUser(AzureUser azureUser) async {
    // const String connectionString =
    //     'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(connectionString);
    final url = Uri.parse(
        '$baseURL(PartitionKey=\'main\',RowKey=\'${azureUser.email}\')');
    return http
        .put(url,
            headers: getHeaders('dashboardusers', connectionString,
                whereClause:
                    '(PartitionKey=\'main\',RowKey=\'${azureUser.email}\')'),
            body: azureUser.toJson())
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

  Future<List<AzureUser>> fetchAzureUsers() {
    // const String connectionString =
    //     'DefaultEndpointsProtocol=https;AccountName=visionscreenerdata;AccountKey=0uJ5hDntTXDyBU/k3VW4xI8s0t+agn1LSZga39J04/Iz2MbCxHOj3/3aeKFKdeacSocW6/vOAD26ilVKYqFYRA==;EndpointSuffix=core.windows.net';
    const String baseURL =
        'https://visionscreenerdata.table.core.windows.net/dashboardusers';
    // final azure = Azure(connectionString);
    final url = Uri.parse('$baseURL?\$top=100');
    return http
        .get(
      url,
      headers: getHeaders('dashboardusers', connectionString),
    )
        .then((response) {
      if (response.statusCode > 299) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
      return json.decode(response.body);
    }).then((json) {
      final dashboardusers = json['value'];
      if (dashboardusers is! List<dynamic>) {
        expectedField('value');
      }
      final List<AzureUser> azureusers = [];
      for (var dashboarduser in dashboardusers) {
        azureusers.add(AzureUser.fromJson(dashboarduser));
      }
      if (kDebugMode) {
        print("Number of users: ${azureusers.length}");
      }
      return azureusers;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
}
