import 'dart:convert';
// import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../azure.dart';
import '../../keys/azure_connection_strings.dart';
import '../model/filter.dart';
// import '../model/azure_user.dart';
import '../model/eyepair.dart';
import '../model/page.dart';

class EyepairNetworkService with Azure {


  EyepairNetworkService();

  Future<void> updateEyepair(String rowKey, String body) {

    const String baseURL =
        'https://uploadphotodata.table.core.windows.net/eyephotos';
    final parameters = '(PartitionKey=\'main\',RowKey=\'$rowKey\')';
    final url = Uri.parse('$baseURL$parameters');
    if (kDebugMode) {
      print(url);
    }
    return http
        .patch(url,
            headers: getHeaders('eyephotos$parameters', dashboardScreeningConnectionString),
            body: body)
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

  Future<EyePair?> fetchEyepair(String rowKey) {

    const String baseURL =
        'https://uploadphotodata.table.core.windows.net/eyephotos';

    final parameters = '?\$filter=(RowKey eq \'$rowKey\')';
    final url = Uri.parse('$baseURL$parameters');
    if (kDebugMode) {
      print(url);
    }
    return http
        .get(
      url,
      headers: getHeaders('eyephotos', dashboardScreeningConnectionString),
    )
        .then((response) {
      if (response.statusCode > 299) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
      return json.decode(response.body);
    }).then((json) {
      final dashboardeyepairs = json['value'];
      if (dashboardeyepairs is! List<dynamic>) {
        expectedField('value');
      }
      final List<EyePair> eyepairs = [];

      for (var eyepair in dashboardeyepairs) {
        if (kDebugMode) {
          print(eyepair);
        }
        return EyePair.fromMap(eyepair);
      }
      return null;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }


  Future<EyepairPage> fetchEyepairs(
      Filter? filter, EyepairPage currentPage, int rowsPerPage) {

    const String baseURL =
        'https://uploadphotodata.table.core.windows.net/eyephotos';
    // final azure = Azure(dashboardScreeningConnectionString);
    final parameters = toParameters(filter, currentPage, rowsPerPage);
    // final url = Uri.parse('$baseURL?\$top=100');
    final url = Uri.parse('$baseURL$parameters');
    if (kDebugMode) {
      print(url);
    }
    String? nextPartitionKey;
    String? nextRowKey;
    return http
        .get(
      url,
      headers: getHeaders('eyephotos', dashboardScreeningConnectionString),
    )
        .then((response) {
      if (response.statusCode > 299) {
        final statusCode = response.statusCode;
        final reasonPhrase = response.reasonPhrase;
        throw Exception('Http response code: $statusCode. $reasonPhrase');
      }
      nextPartitionKey = response.headers["x-ms-continuation-nextpartitionkey"];
      nextRowKey = response.headers["x-ms-continuation-nextrowkey"];
      return json.decode(response.body);
    }).then((json) {
      final dashboardeyepairs = json['value'];
      if (dashboardeyepairs is! List<dynamic>) {
        expectedField('value');
      }
      final List<EyePair> eyepairs = [];
      for (var eyepair in dashboardeyepairs) {
        if (kDebugMode) {
          print(eyepair);
        }
        eyepairs.add(EyePair.fromMap(eyepair));
      }
      if (kDebugMode) {
        print("Number of eyepairs: ${eyepairs.length}");
      }
      return EyepairPage(eyepairs,
          nextPartitionKey: nextPartitionKey, nextRowKey: nextRowKey);
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
}
